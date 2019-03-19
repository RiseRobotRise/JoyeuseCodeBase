extends Navigation
var astar : AStar = AStar.new()


func get_navmesh_path(from: Vector3, to: Vector3):
	var path_points = get_simple_path(from, to, true)
	return path_points


func get_astar_path(from: Vector3, to: Vector3):
	var path_points = astar.get_point_path(astar.get_closest_point(from), astar.get_closest_point(to))
	return path_points


func get_absolute_path(from:Vector3, to:Vector3):
	#First we calculate the Astar path
	var astar_path : Array = get_astar_path(from, to)
	var first_point = astar_path[0]
	#We get the first point of the path
	var last_point = astar_path.back()
	#We get the last point of the path
	
	if from - first_point > 0: 
		#If the first point is too far from the kinematic, calculates a Navmesh Path
		var Initial_path : Array = get_navmesh_path(from, astar.get_point_position(astar.get_closest_point(first_point)))
		Initial_path.invert()
		#Then we add the points to the front of the array 
		for points in Initial_path:
			astar_path.push_front(points)

	
	if (to - last_point).lenght() > 0: 
		#If the path is away from the destination, make a Navmesh path to the destination 
		var Final_path : Array = get_navmesh_path(last_point, astar.get_point_position(astar.get_closest_point(to)))
		#Add the points at the end of the array
		for point in Final_path:
			astar_path.append(point)
			
	#Finally, we return the full path to the given position. 
	return astar_path
	