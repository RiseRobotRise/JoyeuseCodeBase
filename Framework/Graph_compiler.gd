extends Node

var A : Dictionary #= {from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func compile(Connections):
	#Check data types, translate into signals and code. 
	for elements in Connections:
		pass
	pass