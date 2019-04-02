extends MeshInstance

func _ready():
	pass 
func routine():
	if $Floor_center.is_colliding(): #The Tracer must be hitting the floor! (Most of the time, there's an exception to this rule)
		pass
	#First we spawn and search for a corner
	#What is a corner?
	#A corner can either: Have no walls around it
	#Or Have some walls around it
		#Corner Case 1: A wall-less corner, from a plane in the space, won't have any wall colliders, but will have two floor colliders
	#We will register the discovery of a corner
	#If we move up 3 meters the tracer and every floor collider is colliding, it means that we're on the roof. 
	#If we move up 3 meters and there's at least three free colliders, that means we have an elevator. We have to find a better way to calculate this. 
	
	pass