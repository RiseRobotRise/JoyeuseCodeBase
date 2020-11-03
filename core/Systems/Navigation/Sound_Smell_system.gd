extends Spatial
class_name SoundSmellManager, "../../icons/SH_SYSTEM.png"

var active_ai_actors : Array =  []
signal smell_emitted(where, intensity, soundfile)
signal sound_emitted(where, intensity)


func _ready():
	connect("sound_emitted",self,"_on_sound_emitted")
	connect("smell_emitted",self,"_on_smell_emitted")

func _is_valid_character(node:Node):
	var output = false
	if not (node.has_user_signal("heard_something") and node._get("hearing_capability")!=null):
		return true
	if not (node.has_user_signal("smell_smothing") and node._get("smelling_capability")!=null):
		return true

func _register_ai_actor(node):
	if _is_valid_character(node):
		active_ai_actors.append(node)
		active_ai_actors.sort()
	else:
		print("Error registering Actor, please verify")

func _unregister_ai_actor(node):
	var key = active_ai_actors.find(node)
	if key != -1:
		active_ai_actors.remove(key)
	
func get_aprox_pos(position, intensity, property, signal_name):
	var final_intensity
	var pos_aprox
	var distance
	for AI_Actor in active_ai_actors:
		distance = (AI_Actor.translation-position).length()
		if distance >= 0.2:
			final_intensity = intensity / pow(distance,2)
		else:
			final_intensity = intensity
		if final_intensity >= 0.8:
			pos_aprox = (
				position + 
				(RAD.randv(Vector3(0.5,0.5,0.5)*distance)
				/(final_intensity+0.1*AI_Actor.get(property))))
			AI_Actor.emit_signal(signal_name, pos_aprox)
			

func _on_sound_emitted(position, intensity, soundfile = null):
	get_aprox_pos(position, intensity, "hearing_capability", "heard_something")
	if soundfile != null:
		var Sound = AudioStreamPlayer3D.new()
		Sound.stream = load(soundfile)
		Sound.translation = position
		add_child(Sound)
		Sound.play()
		yield(Sound, "finished")
		Sound.queue_free()
	
func _on_smell_emitted(position, intensity):
	get_aprox_pos(position, intensity, "smelling_capability", "smell_something")
