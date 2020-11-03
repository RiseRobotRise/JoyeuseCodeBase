extends JOYCharacter
class_name AI
"""
Interface/Integrator to connect all signals to a behavior tree and provide its functionality
"""

export(String, FILE, "*.jsm") var NPC_File : String = "" #This works just fine! :D
export(String) var initial_state : String = ""
#export(NodePath) var Interactable_Path : NodePath = ""



var BehaviorTree : JxNPC = null
var worker : Worker = Worker.new()


func _ready():

	BehaviorTree = JxNPC.new(NPC_File, initial_state)
	BehaviorTree.actor = self
	BehaviorTree.navigator = $MovementIntegrator
	
	#Worker related functions and signals, setup
	BehaviorTree.worker = worker
	for child in get_children():
		if child is Component:
			child._setup()
	BehaviorTree._create_signal("workstation_assigned")
	BehaviorTree._create_signal("stopped_working")
	BehaviorTree._create_signal("request_rejected")
	worker.connect("request_rejected", self, "_on_request_rejected")
	worker.connect("stopped_working", self, "_on_worker_stopped")
	worker.connect("workstation_assigned", self, "_on_worker_assigned")
	$MovementIntegrator.connect("sight", self, "_on_sight")
	#Workstation setup
	BehaviorTree._create_signal("interacted_by")
	add_child(BehaviorTree)
	#Load settings
#	BehaviorTree.load_colors()

func _process_server(delta):
	worker.work(delta)
	
func _on_sight(info):
	BehaviorTree.emit_signal("sight", info)

func _on_interacted(anything):
	BehaviorTree.emit_signal("interacted_by", anything)

func _on_worker_stopped(category):
	BehaviorTree.emit_signal("stopped_working", category)

func _on_request_rejected():
	BehaviorTree.emit_signal("request_rejected", null)  #Signals must carry at least 1 variable

func _on_worker_assigned(where):
	BehaviorTree.emit_signal("workstation_assigned", where)
