extends JOYCharacter
###################
## AI STEERING ##
var agent : GSAISteeringAgent
var behaviors = {
	"flee" : GSAIBlend.new(agent),
	#flee includes: 
	# Evade
	# Flee
	# Separation
	"pursue" : GSAIBlend.new(agent),
	#pursue includes:
	# Cohesion
	# Pursue
	"keep_range" : GSAIBlend.new(agent)
	# includes:
	# stay at certain distance
}

###################
var current_point : Vector3 = Vector3(0,0,0)
var point_number :int = 0
var AI_PATH : Array = []
var has_destination : bool = false
var has_target : bool = false

onready var world : Node = get_node("root/world")
#### Properties ####
export(float) var attack_min_range = 10
export(float) var attack_max_range = 50

#### Signals ####
signal saw_object(object_info)
signal got_shot(damage, type)
signal heard_something(position)
signal smell_something(position)

###############Basic Movement Functions####################
func update_path(to):
	world = get_node("/root/world")
	has_destination =false
	AI_PATH = world.find_shortest_path(translation, to)
	current_point = AI_PATH[0]
	point_number = 0
	has_destination = true
	print(AI_PATH)
	return AI_PATH

"""
func setup_world():
	if get_parent() is SoundSmellManager:
		SSM = get_parent()
	elif get_parent().get_parent() is SoundSmellManager:
		SSM = get_parent().get_parent()
	else:
		return 
"""

func _ready():
#	setup_world()
	for node in get_children():
		if node is JOYCharacter:
			node.type = "AI_Character"
func _physics_process(delta):
	move_in_path(delta)
func move_in_path(delta):
	if has_destination:
		var vector = (current_point-translation)
		
		if (vector).length() > 2:
			vector = current_point-translation
			
			spatial_move_to(vector, delta)
		else: 
			if point_number < AI_PATH.size()-1:
				point_number += 1
				current_point = AI_PATH[point_number]
		
	else:
		spatial_move_to(Vector3(), delta)


	
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

func decide_dual(motivation, signal1, signal2):
	if motivation < 0.5:
		emit_signal(signal1)
	if motivation > 0.5:
		emit_signal(signal2)

func play_sound(name:String, intensity):
	var stream = load(name)
	if is_valid_sound(stream):
		add_child(AutoSound3D.new(stream, Vector3(0,0,0)))
		world.emit_signal("sound_emitted",translation,intensity)

func is_valid_sound(res):
	var valid_types = [
		AudioStream,
		AudioStreamSample,
		AudioStreamRandomPitch,
		AudioStreamOGGVorbis,
		AudioStreamMicrophone,
		AudioStreamGenerator]
	for type in valid_types:
		if res is type:
			return true
	return false

func decide_fuzzy(motiv1,motiv2,motiv3, signal1, signal2, signal3):
	if motiv3 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal3)
	if motiv2 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal2)
	if motiv1 == max(max(motiv1,motiv2),motiv3):
		emit_signal(signal1)

func dead():
	get_parent()._unregister_AI_Actor(self)
	if bleeds:
		get_parent().emit_signal("smell_emitted",translation,bleeding_smell_intensity)

func nothing(var1 = null, var2 = null, var4= null, var5 = null, var6=null):
	pass

func _on_Eyes_sight(objects, points, normals):
	for object in objects:
		if object is JOYCharacter or object is JOYWorkstation:
			var Objective_info = Decoder.get_object_info(object)
			print_debug("Saw an objective")
			emit_signal("saw_object", Objective_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
