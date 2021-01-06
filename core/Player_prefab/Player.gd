extends Spatial
onready var Cam = $Camera.translation
var Player = Transform()
onready var Player_Node = $Player
onready var Camera_Node = $Camera
onready var target = $"Player/Model/animatedglb/Character/Riggus Universalis/Skeleton/BoneAttachment/Aim_Target"



func _process(delta):
	
	target.global_transform.origin = lerp(target.global_transform.origin, 
		Camera_Node.project_position(get_tree().root.get_visible_rect().size/2, 1)
		, delta*5)
		
	
	Player.origin = $"Player/Model/animatedglb/Character/Riggus Universalis/Skeleton/Head/Camera".global_transform.origin
	Player.basis = $"Player/Model/animatedglb/Character/Riggus Universalis/Skeleton/Head/Camera".global_transform.basis
	
	Camera_Node.global_transform.origin = (lerp(Player.origin, Camera_Node.get_global_transform().origin, delta))
	$Player/weapons.global_transform = Transform(Camera_Node.global_transform.basis,  Camera_Node.global_transform.origin)
#	$Camera.global_transform.basis.x = (lerp($Camera.get_global_transform().basis.x, Player.basis.x, 0.5))
#	$Camera.global_transform.basis.y = (lerp($Camera.get_global_transform().basis.y, Player.basis.y, 0.5))
#	$Camera.global_transform.basis.z = (lerp($Camera.get_global_transform().basis.z, Player.basis.z, 0.5))

func _physics_process(delta):
	Player_Node.turn_transform(Camera_Node.rotation_degrees)
	Player_Node.camera_dir = -Camera_Node.transform.basis.z
	
