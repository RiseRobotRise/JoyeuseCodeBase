extends Spatial
var Cam
var Player
var Player_Node
var Camera_Node

func _ready():
	Cam = $Camera.translation
	Player_Node = $Player
	Camera_Node = $Camera


func _process(delta):
	Player = $Player/CamPos.get_global_transform().origin
	$Camera.global_transform.origin = (lerp($Camera.get_global_transform().origin, Player, 0.5))