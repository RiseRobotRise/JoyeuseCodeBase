extends KinematicBody
class_name Character


#### Character variables ####
# warning-ignore:unused_class_variable
# warning-ignore:unused_variable

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
var gun_list : Array = []
var current_gun = 0
var active_gun : Object
var weapon_point
var hspeed = 0.0


##Weapons and Object Handling
var inventory : Inventory # inventory array to store the objects we are currently holding
var arsenal_links : Array = [null,null,null,null,null,null,null,null,null,null]

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
#### Network vars ####
var slave_linear_vel : Vector3
var slave_translation : Vector3
var slave_transform : Transform
### ENUM ####
enum {
	OBJECTIVE_POSITION = 0,
	OBJECTIVE_TYPE = 1,
	OBJECTIVE_HEALTH = 2,
	OBJECTIVE_TEAM = 3
	}

class Inventory:
	var weapons = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
	var ammo = [0,0,0,0,0,0,0,0,0,0]
	var misc = []
	func add_ammo(id, amount):
		ammo[id]+=amount
	func add_weapon(id, amount):
		weapons[id] = 1
	func reload_weapon(id):
		pass
	func use_item(id, uses):
		if misc.size() > id:
			misc[id] -=1
		if misc[id] < 0:
			misc[id] = 0
		pass 
		

func _ready():
	inventory = Inventory.new()
func _physics_process(delta):
	step_sound_intensity = (weight*(gravity/9.8) * linear_velocity).length()
func apply_impulse(position, direction):
	linear_velocity += direction
	pass
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
				hdir = RAD.adjust_facing(hdir, target_dir, delta, 1.0/hspeed*turn_speed, up)
				

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
			facing_mesh = RAD.adjust_facing(facing_mesh, target_dir, delta, 1.0/hspeed*turn_speed, up)
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
	
	
func holding():
	for i in range(inventory.weapons.size()):
		if inventory.weapons[i] == 0:
			arsenal_links[i].set_visible(false)
		if inventory.weapons[i] == 1:
			arsenal_links[i].set_visible(true)
			active_gun = arsenal_links[i]
		if inventory.weapons[i] == 2:
			pass #Handle dual handling here
			
			
func register_gun(node):
	if node is Weapon:
		if arsenal_links.size() <= node.id:
			arsenal_links.resize(node.id)
		arsenal_links[node.id] = node
		if node.id >= inventory.weapons.size():
			inventory.weapons.resize(node.id)
		inventory.weapons[node.id] = 0
		
	

func pick_up(object, kind = "default", id = 0, dual_pickable=false):
	
	if kind == "ammo":
		if id >= inventory.ammo.size():
			inventory.ammo.resize(id)
		inventory.add_ammo(object, 1)
		return true
	elif kind == "weapon":
		if id >= inventory.weapons.size():
			inventory.weapons.resize(id)
		# does the player have this item yet? 
		# checks the player arsenal to see if it is already there.
		if inventory.weapons[id] == -1: #no

			# increment this item inventory id
			inventory.weapons[id] += 1

			# add object to holding node
			var pickup = object.instance()

			# tell the weapon who we are (to account for who hit who, etc).
			pickup.setup(self)
			print(pickup)
			arsenal_links[id] = pickup
			
			weapon_point.add_child(pickup)
			pickup.set_visible(false)
			return true
		else:
			if dual_pickable and inventory.weapons[id] == 0:
				var pickup = object.instance() 
				arsenal_links[id].dual_wield()
			return false
			
func secondary_fire():
	if active_gun != null:
		if active_gun.has_method("secondary_fire"):
			active_gun.secondary_fire()

func secondary_release():
	if active_gun != null:
		if active_gun.has_method("secondary_release"):
			active_gun.secondary_release()

func primary_fire():
	if active_gun != null:
		if active_gun.has_method("primary_fire"):
			active_gun.primary_fire()

func primary_release():
	if active_gun != null:
		if active_gun.has_method("primary_release"):
			active_gun.primary_release()
