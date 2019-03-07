tool
extends GraphNode

func _ready():
	set_slot(0, true, TYPE_BOOL, Nodes.BOOL, false,0, Color(0,1,0,1))
	set_slot(1, true, TYPE_REAL, Nodes.FLOAT, false, 0 , Color(0,1,0,1))
	set_slot(2, false, 0, Color(1,1,1,1), true, TYPE_BOOL, Nodes.BOOL)
	set_slot(3, false, 0, Color(1,1,1,1), true, TYPE_BOOL, Nodes.BOOL)
	set_slot(4, false, 0, Color(1,1,1,1), true, TYPE_BOOL, Nodes.BOOL)
