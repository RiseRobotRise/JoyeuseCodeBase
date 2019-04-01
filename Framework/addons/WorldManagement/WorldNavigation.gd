extends Navigation
var astar : AStar = AStar.new()

####################### TEMP ###############################
var camrot= 0.0
var camrot2 = 0.0
var m = SpatialMaterial.new()
func _ready():
	calculate_astar()
	#set_process_input(true)

	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color(1.0, 1.0, 1.0, 1.0)

func _input(event):
#	if event extends InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var from = get_node("cambase/Camera").project_ray_origin(event.position)
		var to = from + get_node("cambase/Camera").project_ray_normal(event.position)*100
		var p = get_closest_point_to_segment(from, to)
		
		var PATH = get_node("KinematicBody").update_path(p)
		get_node("KinematicBody").has_destination = true
		
	
		var im = get_node("draw")
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(PATH[0])
		im.add_vertex(p)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in PATH:
			im.add_vertex(x)
		im.end()
	
	if event is InputEventMouseMotion:
		if event.button_mask&(BUTTON_MASK_MIDDLE+BUTTON_MASK_RIGHT):
			camrot += event.relative.x * 0.005
			camrot2 += event.relative.y * 0.005
			get_node("cambase").set_rotation(Vector3(camrot2, camrot, 0))
			print("camrot ", camrot)
			

func find_shortest_path(from: Vector3, to : Vector3):
	var absoulut = get_absolute_path(from, to)
	var navmesh = get_navmesh_path(from, to)
	if min(absoulut.size(),navmesh.size()) == absoulut.size():
		return absoulut
	else:
		return navmesh 


func get_navmesh_path(from: Vector3, to: Vector3):
	var path_points = get_simple_path(from, to, true)
	return path_points


func get_astar_path(from: Vector3, to: Vector3):
	var path_points = astar.get_point_path(astar.get_closest_point(from), astar.get_closest_point(to))
	return path_points


func get_absolute_path(from:Vector3, to:Vector3):
	#First we calculate the Astar path
	var astar_path : Array = get_astar_path(from, to)
	print("First Astar point is" + str(astar_path[0]))
	print("Last Astar point is" + str(astar_path[astar_path.size()-1]))
	print("origin is" + str(from))
	print("destination is" + str(to))
	var first_point = astar_path[0]
	#We get the first point of the path
	var last_point = (astar_path.invert()) #The astar path is backwards
	last_point = astar_path[0]
	#astar_path.invert()
	#We get the last point of the path
	
	if (from - first_point).length() > 0: 
		#If the first point is too far from the kinematic, calculates a Navmesh Path
		var Initial_path : Array = get_navmesh_path(from, astar.get_point_position(astar.get_closest_point(first_point)))
		Initial_path.invert()
		#Then we add the points to the front of the array 
		for points in Initial_path:
			astar_path.push_back(points)
	
	astar_path.invert() #The astarpath is forwards 
	
	if (to - last_point).length() > 0: 
		#If the path is away from the destination, make a Navmesh path to the destination 
		var Final_path : Array = get_navmesh_path(last_point, astar.get_point_position(astar.get_closest_point(to)))
		#Add the points at the end of the array
		for point in Final_path:
			astar_path.append(point)
			
	#Finally, we return the full path to the given position. 
	return astar_path
	
func calculate_astar():
	var AstarPath = $Path.get_curve()
	for  x in AstarPath.get_point_count(): #Get all points in the Curve 3D
		var Point = AstarPath.get_point_position(x) #Get their positions
		astar.add_point(x, Point) #Add them to the A* calculation
		if x != 0:
			astar.connect_points(x,x-1) #If they are not out of index, connect them
	print(astar.get_points())
	astar.connect_points(0,astar.get_points()[-1])