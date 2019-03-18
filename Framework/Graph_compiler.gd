extends GraphEdit

var A : Dictionary #= {from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
var Currently_selected : Node = null
func _ready():
	connect("node_selected", self, "_on_node_selected")


func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("Shift") and Input.is_key_pressed(KEY_A):
			$MainMenu.rect_position = get_tree().get_root().get_mouse_position()
			$MainMenu.popup()
		if Input.is_key_pressed(KEY_DELETE) and Currently_selected != null:
			var all_connections : Array = get_connection_list()
			for connection in all_connections:
				var from_port = connection.get("from_port")
				var from = connection.get("from")
				var to_port = connection.get("to_port")
				var to = connection.get("to")
				if (Currently_selected.name == from or Currently_selected.name == to):
					disconnect_node(from,from_port,to,to_port)
			Currently_selected.clear_all_slots()
			Currently_selected.queue_free()
			update()
			
func compile(Connections):
	#Check data types, translate into signals and code. 
	for elements in Connections:
		pass
	pass
func _on_node_selected(node):
	Currently_selected = node

func _on_Button3_pressed():
	print(get_connection_list())
	pass # Replace with function body.

	