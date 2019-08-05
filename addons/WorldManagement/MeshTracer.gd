tool
extends KinematicBody
var Direction : Vector3 = Vector3(0,0,0)
var normal : Vector3 = Vector3(0,1,0)
onready var parent = get_parent()

func stop():
	Direction = Vector3(0,0,0)
	#parent.state = -1
func get_normals():
	var output : Array = [
	$Front.get_collision_normal(),
	$Back.get_collision_normal(),
	$Left.get_collision_normal(),
	$Right.get_collision_normal()
	]
	return output
	
func get_colliders():
	var output : Array = [
	$Front.get_collider(),
	$Back.get_collider(),
	$Left.get_collider(),
	$Right.get_collider(),
	$Floor_center.get_collider()
	]
	return output
	
func check_colliders():
	var floorCollide = [
	$Floor_front.is_colliding(),
	$Floor_back.is_colliding(),
	$Floor_left.is_colliding(),
	$Floor_right.is_colliding()
	]
	var wallCollide = [
	$Front.is_colliding(),
	$Back.is_colliding(),
	$Left.is_colliding(),
	$Right.is_colliding()
	]
	var output : Array = [
	floorCollide,
	wallCollide
	]
	return output

#func routine():
#	if $Floor_center.is_colliding(): #The Tracer must be hitting the floor! (Most of the time, there's an exception to this rule)
#		print("Collided with floor!")
#		if check_colliders()[1][0]: #Checks for [Walls][Front]
#			parent.state = 1
#			print("Collided in front!")
#		if check_colliders()[1][1]:
#			parent.state = 2
#			print("Collided in back!")
#		if check_colliders()[1][2]:
#			parent.stateLateral = 1
#			print("Collided in left!")
#		if check_colliders()[1][3]:
#			parent.stateLateral = 2
#			print("Collided in right!")
		#else:
		#	parent.state = 0 
		#	parent.stateLateral = 0
		
	#First we spawn and search for a corner
	#What is a corner?
	#A corner can either: Have no walls around it
	#Or Have some walls around it
		#Corner Case 1: A wall-less corner, from a plane in the space, won't have any wall colliders, but will have two floor colliders
	#We will register the discovery of a corner
	#If we move up 3 meters the tracer and every floor collider is colliding, it means that we're on the roof. 
	#If we move up 3 meters and there's at least three free colliders, that means we have an elevator. We have to find a better way to calculate this. 
#	else:
#		stop()
#func state_check():
	#parent.prevstate = parent.state
	#parent.prevLateral = parent.stateLateral
#	if parent.state == 1:
#		Direction = normal.cross(get_normals()[0]) #Checks for [Front]
#	if parent.state == 2:
#		Direction = normal.cross(get_normals()[1]) #Checks for [Back]
#	if parent.stateLateral == 1: 
#		Direction = normal.cross(get_normals()[2]) #Checks for [Left]
#	if parent.stateLateral == 2: 
#		Direction = normal.cross(get_normals()[3]) #Checks for [Right]
	
	#if parent.prevstate == 0:
	#	if parent.prevstate == 1:
	##		Direction = $Front.cast_to
	#	if parent.prevstate == 2:
	#		Direction = $Back.cast_to
	#	if parent.prevLateral == 3: 
	#		Direction == $Left.cast_to
	#	if parent.prevLateral == 3: 
	#		Direction == $Right.cast_to

func _physics_process(delta):
	call_deferred("routine")
	call_deferred("state_check")
	move_and_slide(Direction.normalized()*20, normal)
