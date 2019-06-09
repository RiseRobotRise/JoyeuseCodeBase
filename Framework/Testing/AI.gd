class_name AI_Character
extends Character


onready var WORLD = get_node("/root/world")
var current_point : Vector3 = Vector3(0,0,0)
var point_number :int = 0
var AI_PATH : Array = []
var has_destination = false

#### Signals ####
signal got_shot(why)

###############Basic Movement Functions####################
func update_path(to):
	has_destination =false
	AI_PATH = WORLD.find_shortest_path(translation, to)
	current_point = AI_PATH[0]
	point_number = 0
	has_destination = true
	print(AI_PATH)
	return AI_PATH
	
	
func update_direction(path_points: Array):
	var i : int = 0
	var point = path_points[i]
	var direction = point - translation
	while direction.lenght() > 0:
		direction = point - translation
		if direction.lenght() <= 0.1:
			i+=1
		return direction

func move(to):
	update_path(to)
	has_destination = true


##############Behavioral Functions##########################

func walk(to):
	pass
	
func flee(from):
	pass

func shoot(to):
	pass

func decide_dual(motivation):
	pass

func decide_fuzzy(motiv1,motiv2,motiv3, signal1, signal2, signal3):
	if motiv3 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal3)
	if motiv2 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal2)
	if motiv1 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal1)
	pass

##################Compiled behavior############################


func _ready():
	pass
	
func _process(delta):
	if has_destination:
		var vector = (current_point-translation)
		
		if (vector).length() > 1:
			vector = current_point-translation
			
			spatial_move_to(vector, delta)
		else: 
			if point_number < AI_PATH.size()-1:
				point_number += 1
				current_point = AI_PATH[point_number]
				print("translation is" + str(translation))
		
	else:
		spatial_move_to(Vector3(), delta)
	

func _on_Eyes_sight(objects, points, normals):
	for object in objects:
		if object is AI_Character or object is Player:
			var Objective = RAD._get_object_info(object)
