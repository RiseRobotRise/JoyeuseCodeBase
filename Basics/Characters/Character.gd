extends KinematicBody
class_name Character


#### Character variables ####

var type = "Character"
var team = 0
var health = 100
var jumping = false
var hearing_capability = 1
var smelling_capablity = 1
var bleeds = true
var bleeding_smell_intensity = 10
var step_sound_intensity = 0 # This is calculated from physics values



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
var jump_attempt = false
export(float) var grav = 9.8
var linear_velocity = Vector3()
var gravity = Vector3(0,-grav,0)
var up = Vector3()
export(float) var speedfactor = 0.8
var sharp_turn_threshold = 140
### ENUM ####
enum {
	OBJECTIVE_POSITION = 0,
	OBJECTIVE_TYPE = 1,
	OBJECTIVE_HEALTH = 2,
	OBJECTIVE_TEAM = 3
	}
func _physics_process(delta):
	step_sound_intensity = weight*(gravity/9.8) * linear_velocity.length()

func spatial_move_to(vector,delta):
	
	if not flies:
		linear_velocity += gravity*delta/weight

	if fixed_up:
		up = Vector3(0,1,0) # (up is against gravity)
	else:
		up = -gravity.normalized()
	var vertical_velocity = up.dot(linear_velocity) # Vertical velocity
	var horizontal_velocity = linear_velocity - up*vertical_velocity # Horizontal velocity
	var hdir = horizontal_velocity.normalized() # Horizontal direction
	var hspeed = horizontal_velocity.length()*speedfactor

	#look_at(vector, Vector3(0,1,0)) #Change to something that turns to the player or something they have to see

	var target_dir = (vector - up*vector.dot(up)).normalized()

	if (is_on_floor()): #Only lets the character change it's facing direction when it's on the floor.
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

		set_transform(Transform(m3, mesh_xform.origin))

		if (not jumping and jump_attempt):
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
				hspeed = hspeed - (deaccel*0.2)*delta
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

	linear_velocity = move_and_slide(linear_velocity,-gravity.normalized())
