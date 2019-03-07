extends Tabs

var type : int
var indx  : int
var actions = [preload("res://Nodes/Actions/Walk.tscn")]
var stimulus = [
	preload("res://Nodes/Stimulus/Damaged.tscn"),
	preload("res://Nodes/Stimulus/Onsight.tscn")]
var inhibitors = [
	preload("res://Nodes/Inhibitors/Decision.tscn"), 
	preload("res://Nodes/Inhibitors/Preservation.tscn")
	]
var customs
var store = [stimulus,inhibitors,actions,customs]

func _ready():
	var Stimulus = $VSplitContainer/Panel/HBoxContainer/Stimulus.get_popup()
	var Inhibits = $VSplitContainer/Panel/HBoxContainer/Custom.get_popup()
	var Actions = $VSplitContainer/Panel/HBoxContainer/Actions.get_popup()
	var Behave = $VSplitContainer/Panel/HBoxContainer/Inhibitions.get_popup()
	Stimulus.connect("index_pressed",self,"_on_Stimulus_selected")
	Inhibits.connect("index_pressed",self,"_on_Inhibitors_selected")
	Actions.connect("index_pressed",self,"_on_Actions_selected")
	Behave.connect("index_pressed",self, "_on_Inhibitions_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Stimulus_selected(index):
	type = 0
	indx = index
	update_labels()
func _on_Inhibitors_selected(index):
	type = 3
	indx = index
	update_labels()
func _on_Actions_selected(index):
	type = 2
	indx = index
	update_labels()
func _on_Inhibitions_selected(index):
	type = 1
	indx = index
	update_labels()
func update_labels():
	var Placeholder = store[type][indx].instance()
	$VSplitContainer/HSplitContainer/VSplitContainer/VBoxContainer/selection/name.text = str(Placeholder.title)
	$VSplitContainer/HSplitContainer/VSplitContainer/VBoxContainer/type/name
	Placeholder.queue_free()

func _on_Add_node_pressed():
	$VSplitContainer/HSplitContainer/GraphEdit.add_child(store[type][indx].instance())

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	if from != to:
		$VSplitContainer/HSplitContainer/GraphEdit.connect_node(from, from_slot, to, to_slot)
