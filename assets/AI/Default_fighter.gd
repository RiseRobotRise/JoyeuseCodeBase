extends AI_Character


func _ready():
	self.connect("saw_object",self,"object_seen") 
	
	
func object_seen(object):
	RAD.debug_print("The AI has seen something")
	if object[OBJECTIVE_TYPE] == "AI_Character" or object[OBJECTIVE_TYPE] == "Player":
		if not has_target:
			move(object[OBJECTIVE_POSITION])
			has_target = true
		RAD.debug_print("The AI has seen an objective")

func roam_around():
	move(translation+RAD.randv(Vector3(3,3,3)))
	
func state_change():
	roam_around()
