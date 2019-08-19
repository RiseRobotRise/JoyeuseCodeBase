extends Spatial
var Cam
var Player = Transform()
var Player_Node
var Camera_Node

func _ready():
	Cam = $Camera.translation
	Player_Node = $Player
	Camera_Node = $Camera


func _process(delta):
	Player.origin = $Player/CamPos.get_global_transform().origin
	Player.basis = $Player/CamPos.get_global_transform().basis
	$Camera.global_transform.origin = (lerp($Camera.get_global_transform().origin, Player.origin, 0.5))
	$Player/weapons.global_transform = Transform($Camera.global_transform.basis,  $Camera.global_transform.origin)
#	$Camera.global_transform.basis.x = (lerp($Camera.get_global_transform().basis.x, Player.basis.x, 0.5))
#	$Camera.global_transform.basis.y = (lerp($Camera.get_global_transform().basis.y, Player.basis.y, 0.5))
#	$Camera.global_transform.basis.z = (lerp($Camera.get_global_transform().basis.z, Player.basis.z, 0.5))