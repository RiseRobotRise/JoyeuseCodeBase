extends MeshInstance

func _ready():
	pass # Replace with function body.
func routine():
	if $Floor_center.is_colliding(): #The Tracer must be hitting the floor!
		pass
	#First we spawn and search for a corner
	#What is a corner?
	#A corner can either: Have no walls around it
	#Or Have some walls around it
	pass