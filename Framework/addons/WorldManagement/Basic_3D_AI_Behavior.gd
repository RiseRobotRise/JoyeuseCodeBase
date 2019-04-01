extends KinematicBody



#AI Characteristics
export(bool) var AI_active = true
export(bool) var static_AI = false
export(int) var Team = 0
export(bool) var is_worker = false
export(int) var indifference = 10
export(float) var smellarea = 5
export(float) var heararea = 10
export(float) var health = 100



#time for timers
export(int) var timewaiting = 2


#Movement Values


#Globals
var initialized = false
var on_workstation = false
var workstation_near = false
var player_near = false
var is_on_sight = false
var visible_obj
var current_target
var up
var has_target = false


var position =Vector3(0,0,0)
var randposition =Vector3(0,0,0)


var jump_attempt = false

var globaldelta = 0.0
var CHAR_SCALE = Vector3(1, 1, 1)
var is_moving = false



func _ready():
	add_child(preload("res://addons/WorldManagement/3D_AI.tscn").instance())
	$AI/Wait.wait_time = timewaiting
	$AI/Senses/SmellandHear/CollisionShape.shape.radius = smellarea
	$AI/Senses/Hear/CollisionShape.shape.radius = heararea
	var groups = get_groups()
	visible_obj = $AI/Senses/SmellandHear/Eyes
	set_process(true)

	Spatial_Routine()
	CHAR_SCALE = scale
	initialized = true


func Spatial_Routine():
	#idle()
	$AI/Wait.connect("timeout", self, "switch_waiting")
	#$AI/Hunt.connect("timeout", self, "Hunting")
	#$AI/Work.connect("timeout", self, "Work")
	$AI/Wander.connect("timeout", self, "new_position")
	$AI/NewSearch.connect("timeout", self, "reset_target")
	$AI/Senses/SmellandHear.connect("area_entered", self, "check_area")
	$AI/Senses/SmellandHear.connect("body_entered", self, "check_body")
	$AI/Senses/Hear.connect("body_entered", self, "check_sound")
	#Spatial_Routine()

func reset_target():
	has_target = false 
	current_target = null

func switch_waiting():
	if is_moving:
		is_moving = false
		pass
	else:
		is_moving = true
		pass
func Work():
	if on_workstation:
		do_work()
	else:
		walk()

func Hunting():
	if player_near and not static_AI:
		Chase()
	else:
		if is_on_sight:
			attack()



func check_area(object):
	#for x in object.get_groups():
	#	print(to_global(object.translation))
	#	print(object.translation)
	#	if x == "Workstation" and is_worker and indifference==10:
	#		position = object.translation
	#		workstation_near = true
	#	if x == "Workstation" and is_worker and (indifference >= 1 and indifference <=5):
	#		#Killenemies()
	#		position = object.translation
	#		workstation_near = true
#		if x == "Workstation" and is_worker and indifference == 0:
#			#Killallenemies()
#			position = object.translation
#			workstation_near = true
	pass

func check_body(object):
	pass

func wander():
	if workstation_near and not has_target:
		#var vectorpos = (position-translation).normalized()
		Spatial_move_to(position, globaldelta)
	if not has_target:
		Spatial_move_to(randposition, globaldelta)
		#var vectorpos = (position-translation).normalized()
		Spatial_move_to(position, globaldelta)
	if has_target:
		Spatial_move_to(current_target.translation, globaldelta)

func Spatial_move_to(vector,delta):
	vector = vector - translation
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
				var facing_dir = hdir

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
		var m3 = Basis(-facing_mesh, up, -facing_mesh.cross(up).normalized()).scaled(CHAR_SCALE)

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

func _process(delta):
	if AI_active:
		globaldelta = delta
		if is_moving:
			wander()
		else:
			Spatial_move_to(translation,delta)
		AI_is_seeing()
	
		if (translation-current_target.translation > Vector3(heararea,heararea,heararea)) or (visible_obj.get_collider() != current_target):
			position = Vector3(current_target.translation.x, current_target.translation.y, current_target.translation.z)
			$AI/NewSearch.start() #It's not looking at the target, has ten seconds to find it. 
		else: #It's looking at the target now. 
			if not $AI/NewSearch.is_stopped(): #Is it counting to change target? 
				$AI/NewSearch.stop() #Cancels the timer to look for another target

func new_position():
	if not has_target:
		randposition = Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1))
	if $AI/Senses/SmellandHear/Checkheight.is_colliding():
		#new_position()
		pass
	

func AI_is_seeing():
	if visible_obj.is_colliding():
		var obj_seen_grps = visible_obj.get_collider().get_groups()
		for x in obj_seen_grps:
			
			if x == "Workstation" and is_worker:
				if visible_obj.get_collider().functional == true:
					current_target = visible_obj.get_collider()
					position = current_target.translation
					has_target = true
			
			if (x == "Player" or x == "AI")  and not visible_obj.get_collider().Team == Team:
				current_target = visible_obj.get_collider()
				position = current_target.translation
				has_target = true
				
			
			
			else:
				if not has_target and (visible_obj.get_collider() is KinematicBody):
					var WorkPos = visible_obj.get_collider().translation
					Spatial_move_to(WorkPos, globaldelta)

func AI_Check_Target_State():
	if current_target.Health != 0:
		Attack()
		




func attack():
	pass

func aim_and_shoot():
	pass

func search():
	Spatial_move_to(Vector3(0.1,0.1,0.1),globaldelta)
	Spatial_move_to(Vector3(0.1,0.1,-0.1),globaldelta)
	Spatial_move_to(Vector3(-0.1,0.1,0.1),globaldelta)
	Spatial_move_to(Vector3(-0.1,0.1,-0.1),globaldelta)

	pass
