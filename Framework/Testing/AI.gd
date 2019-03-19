extends KinematicBody
onready var WORLD = get_node("/root/world")

var AI_PATH : Array = []

###############Basic Movement Functions####################
func update_path(to):
	AI_PATH = WORLD.get_absolute_path(translation, to)
	
	
func update_direction(path_points: Array):
	var i : int = 0
	var point = path_points[i]
	var direction = point - translation
	while direction.lenght() > 0:
		direction = point - translation
		if direction.lenght() <= 0.1:
			i+=1
		return direction

func move_on_linear(to):
	pass
	
func move(to):
	
	pass

##############Behavioral Functions##########################

func walk(to):
	pass
	
func flee(from):
	pass

func shoot(to):
	pass

func decide_dual(motivation):
	pass

func decide_fuzzy(motiv1,motiv2,motiv3):
	if motiv3 == max(max(motiv1,motiv2),motiv3):
		pass
	if motiv2 == max(max(motiv1,motiv2),motiv3):
		pass
	if motiv1 == max(max(motiv1,motiv2),motiv3):
		pass
	pass

##################Compiled behavior############################


func _ready():
	pass