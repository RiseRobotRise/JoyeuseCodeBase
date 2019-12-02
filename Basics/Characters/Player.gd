extends Character
class_name Player, "../../icons/player.png"

var current_state = 0 
enum {
	IDLE = 1,
	WALK = 2,
	RUN = 3,
	COMBAT = 4,
	DEAD = 6
}
export(bool) var AlowCameraChange
export(PackedScene) var Gun

func _ready():
	set_process_input(true)
	weapon_point = $weapons
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	type = "Player"
	team = 1
	maxhealth = 300
	current_state = IDLE
	update_inventory()

#func _init(_type, _team, _gun):
#	type = _type
#	team = _team
#	Gun = _gun
	





func _physics_process(delta):
	var dir = Vector3()
	#THIS BLOCK IS INTENDED FOR FPS CONTROLLER USE ONLY
	var aim = get_parent().get_node("Camera").get_global_transform().basis
	if ( not get_tree().has_network_peer()):
		get_parent().Camera_Node.make_current()
		
		if Input.is_action_pressed("shoot"):
			primary_fire() 
			
		if Input.is_action_pressed("shoot_secondary"):
			secondary_fire()
		
		if Input.is_action_just_released("shoot_secondary"):
			secondary_release()
		
		if Input.is_action_just_pressed("prev_weapon"):
			last_weapon()
		
		if Input.is_action_just_pressed("next_weapon"):
			next_weapon()
		
		if (Input.is_action_pressed("move_forwards")):
			dir -= aim[2]
		if (Input.is_action_pressed("move_backwards")):
			dir += aim[2]
		if (Input.is_action_pressed("move_left")):
			dir -= aim[0]

#			$Pivot/FPSCamera.Znoice =  1*hspeed

		if (Input.is_action_pressed("move_right")):
			dir += aim[0]
#			$Pivot/FPSCamera.Znoice =  -1*hspeed
		if get_tree().has_network_peer():
			rset("slave_linear_vel", linear_velocity)
			rset("slave_translation", translation)
			rset("slave_transform", get_parent().get_node("Player/Model").transform)
	else:
		get_parent().get_node("Player/Model").transform = slave_transform
		translation = slave_translation
		linear_velocity = slave_linear_vel
		
	jump_attempt = Input.is_action_pressed("jump")
	shoot_attempt = Input.is_action_pressed("shoot")

	
	spatial_move_to(dir, delta, false)
	
#	$Model.transform = ModelTransform




	
func update_inventory():
	for gun in weapon_point.get_children():
		gun.setup(self)
		register_gun(gun)
	next_weapon()
	holding()
	
func next_weapon(attempts = 0):
	if inventory.weapons[current_gun] != -1:
		print("Current gun, index: ", current_gun, " exists, setting it to 0")
		inventory.weapons[current_gun] = 0
	print("attempt to get next gun")
	if attempts < inventory.weapons.size():
		print("attempts available")
		if current_gun == inventory.weapons.size()-1:
			print("returning to the front of the array at attempt :", attempts)
			current_gun = 0
		else:
			print("going to the next id in the array")
			current_gun += 1
			
		if inventory.weapons[current_gun] == -1:
			print("this one isn't available yet")
			var t = next_weapon(attempts+1)
			if t == -1:
				print("No gun was found")
				return
		else:
			print("Found an available gun")
			inventory.weapons[current_gun] = 1
			holding()
	else:
		print("Attempts have run out")
		return -1
		
		
func last_weapon(attempts = 0):
	if inventory.weapons[current_gun] != -1:
		inventory.weapons[current_gun] = 0
	if attempts < inventory.weapons.size():
		if current_gun == 0:
			current_gun = inventory.weapons.size()-1
		else:
			current_gun -= 1
			
		if inventory.weapons[current_gun] == -1:
			var t = last_weapon(attempts+1)
			if t == -1:
				return
		else:
			inventory.weapons[current_gun] = 1
			holding()
	else:
		return -1