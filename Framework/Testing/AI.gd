extends KinematicBody


var AI_PATH : Array = []

###############Basic Movement Functions####################

func move_on_NavMesh(to):
	pass

func move_on_AStar(to):
	pass

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