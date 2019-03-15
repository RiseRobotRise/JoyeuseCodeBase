tool
extends GraphNode

func _ready():
	set_slot(0,true,TYPE_BOOL,Nodes.BOOL,false,TYPE_BOOL,Nodes.BOOL)
	set_slot(1,true,TYPE_VECTOR3,Nodes.VECTOR,false,TYPE_BOOL,Nodes.BOOL)
