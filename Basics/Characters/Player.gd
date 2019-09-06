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
	$weapons/fusion_pistol.setup(self)

#func _init(_type, _team, _gun):
#	type = _type
#	team = _team
#	Gun = _gun
	


func primary_fire():
	#print("attempting to fire!")
	var held_weapon = weapon_point.get_children()
	if held_weapon.size() > 0:
		if held_weapon[0].has_method("primary_fire"):
			#print("click!")
			held_weapon[0].primary_fire()


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
		
		if Input.is_action_just_pressed("last_weapon"):
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
func secondary_fire():
	#print("attempting to fire!")
	var held_weapon = weapon_point.get_children()
	if held_weapon.size() > 0:
		if held_weapon[0].has_method("primary_fire"):
			#print("click!")
			held_weapon[0].secondary_fire()

func secondary_release():
	#print("attempting to fire!")
	var held_weapon = weapon_point.get_children()
	if held_weapon.size() > 0:
		if held_weapon[0].has_method("secondary_release"):
			#print("click!")
			held_weapon[0].secondary_release()
			
func last_weapon():
	#var held = is_held()
	#var size = is_held().size()
	#$Pivot/weapon_point.move_child(held[size-1], 0)
	pass
	
func next_weapon():
	#var held = is_held()
	#var size = is_held().size()
#	$Pivot/weapon_point.move_child(held[0], size)
	pass