extends KinematicBody
class_name JOYCharacter

enum {
	OBJECTIVE_POSITION = 0,
	OBJECTIVE_TYPE = 1,
	OBJECTIVE_HEALTH = 2,
	OBJECTIVE_TEAM = 3
	}


#### Character variables ####
# warning-ignore-all:unused_class_variable
# warning-ignore-all:unused_variable

var type : String = "Character"
var team : int = 0
var health : int = 100
var shield : int = 0
var maxhealth : int = 100
var maxshield : int = 100
var jumping : bool = false
var hearing_capability : int = 1
var smelling_capablity : int = 1
var bleeds : bool = true
var bleeding_smell_intensity : int = 10
var step_sound_intensity : float = 0 # This is calculated from physics values
var object_list : Array = []
var current_object = 0
var active_object : Object
var weapon_point : Node
var hspeed : float = 0.0


##Weapons and Object Handling
var inventory : Inventory = Inventory.new() # inventory to store the objects we are currently holding


#### Movement and physics variables ####
 
export(bool) var flies = false
export(bool) var fixed_up = true
export(float) var weight = 1
export(float) var max_speed = 10
export(int) var turn_speed = 40
export(float) var accel = 19.0
export(float) var deaccel = 14.0
export(bool) var keep_jump_inertia = true
export(bool) var air_idle_deaccel = false
export(float) var JumpHeight = 7.0
var jump_attempt : bool = false
var shoot_attempt : bool = false
export(float) var grav = 9.8

var linear_velocity = Vector3()
var gravity = Vector3(0,-grav,0)
var up = Vector3()
export(float) var speedfactor = 0.8
var sharp_turn_threshold = 140


#### Network vars #####################
puppet var puppet_linear_vel : Vector3
puppet var puppet_translation : Vector3
puppet var puppet_transform : Transform
#######################################

func adjust_facing(p_facing, p_target, p_step, p_adjust_rate, current_gn):
	var n = p_target # Normal
	var t = n.cross(current_gn).normalized()

	var x = n.dot(p_facing)
	var y = t.dot(p_facing)

	var ang = atan2(y,x)

	if (abs(ang) < 0.001): # Too small
		return p_facing

	var s = sign(ang)
	ang = ang*s
	var turn = ang*p_adjust_rate*p_step
	var a
	if (ang < turn):
		a = ang
	else:
		a = turn
	ang = (ang - a)*s
	return (n*cos(ang) + t*sin(ang))*p_facing.length()

func _ready():
#	inventory = Inventory.new()
	pass

func _physics_process(delta):
	step_sound_intensity = (weight*(gravity/9.8) * linear_velocity).length()
	
func apply_impulse(position, direction):
	linear_velocity += direction

func spatial_move_to(vector,delta,locked=true):
	
	if not flies:
		linear_velocity += gravity*delta/weight

	if fixed_up:
		up = Vector3(0,1,0) # (up is against gravity)
	else:
		up = -gravity.normalized()
	var vertical_velocity = up.dot(linear_velocity) # Vertical velocity
	var horizontal_velocity = linear_velocity - up*vertical_velocity # Horizontal velocity
	var hdir = horizontal_velocity.normalized() # Horizontal direction
	hspeed = horizontal_velocity.length()*speedfactor

	#look_at(vector, Vector3(0,1,0)) #Change to something that turns to the player or something they have to see

	var target_dir = (vector - up*vector.dot(up)).normalized()
	if vector.length() <= 0:
		target_dir = (linear_velocity - up*vector.dot(up)).normalized()

	if (is_on_floor() or not locked): #Only lets the character change it's facing direction when it's on the floor.
		var sharp_turn = hspeed > 0.1 and rad2deg(acos(target_dir.dot(hdir))) > sharp_turn_threshold

		if (vector.length() > 0.1 and !sharp_turn):
			if (hspeed > 0.001):
				#linear_dir = linear_h_velocity/linear_vel
				#if (linear_vel > brake_velocity_limit and linear_dir.dot(ctarget_dir) < -cos(Math::deg2rad(brake_angular_limit)))
				#	brake = true
				#else
				hdir = adjust_facing(hdir, target_dir, delta, 1.0/hspeed*turn_speed, up)
			else:
				hdir = target_dir
			if (hspeed < max_speed):
				hspeed += accel*delta
		else:
			hspeed -= deaccel*delta
			if (hspeed < 0):
				hspeed = 0
		horizontal_velocity = hdir*hspeed
		var mesh_xform = get_transform()
		var facing_mesh = -mesh_xform.basis[0].normalized()
		facing_mesh = (facing_mesh - up*facing_mesh.dot(up)).normalized()

		if (hspeed>0):
			facing_mesh = adjust_facing(facing_mesh, target_dir, delta, 1.0/hspeed*turn_speed, up)
		var m3 = Basis(-facing_mesh, up, -facing_mesh.cross(up).normalized()).scaled(scale)
		var ModelTransform = Transform(m3, mesh_xform.origin)
		set_transform(ModelTransform)
		if (not jumping and jump_attempt) and is_on_floor():
			vertical_velocity = JumpHeight
			jumping = true
			#get_node("sound_jump").play()
	else:
		if (vector.length() > 0.1):
			horizontal_velocity += target_dir*accel*delta
			if (horizontal_velocity.length() > max_speed):
				horizontal_velocity = horizontal_velocity.normalized()*max_speed
		else:
			if (air_idle_deaccel):
				hspeed -= (deaccel*0.2)*delta
				if (hspeed < 0):
					hspeed = 0
				horizontal_velocity = hdir*hspeed
	if (jumping and vertical_velocity < 0):
		jumping = false
	if not flies:
		linear_velocity = horizontal_velocity + up*vertical_velocity
	else:
		linear_velocity = horizontal_velocity
	if (is_on_floor()):
		var movement_dir = linear_velocity
	linear_velocity = move_and_slide(linear_velocity, up)

func hit(damage):
	health -= damage
	
func add_health(mnt, FillsShield):
	if not FillsShield and health < maxhealth:
		health += mnt
	if FillsShield:
		if health < maxhealth:
			health += mnt
		elif shield < maxshield:
			shield += mnt
	shield = clamp(shield, 0, maxshield)
	health = clamp(health, 0, maxhealth)
	
	
func update_visibility():
	return
	for i in range(inventory.weapons.size()):
		if inventory.weapons[i] == 0:
			inventory.arsenal_links[i].set_visible(false)
		if inventory.weapons[i] == 1:
			inventory.arsenal_links[i].set_visible(true)
			active_object = inventory.arsenal_links[i]
		if inventory.weapons[i] == 2:
			pass #Handle dual handling here

func pick_up(object, kind = "default", id = 0, dual_pickable=false):
	inventory.register_object(object)
	return
	

			
func secondary_use():
	if active_object != null:
		if active_object.has_method("secondary_use"):
			active_object.secondary_use()

func secondary_release():
	if active_object != null:
		if active_object.has_method("secondary_release"):
			active_object.secondary_release()

func primary_use():
	if active_object != null:
		if active_object.has_method("primary_use"):
			active_object.primary_use()

func primary_release():
	if active_object != null:
		if active_object.has_method("primary_release"):
			active_object.primary_release()
