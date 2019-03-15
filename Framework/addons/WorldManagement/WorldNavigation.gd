extends Navigation

func _ready():
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
#	TraceAllMeshes(self)


#func TraceAllMeshes(node):
#	print(node)
#	for N in node.get_children():
#		print(N)
#		if N.is_class("MeshInstance"):
#			var a = NavigationMeshInstance.new()
#			N.add_child(a)
#			print(a)
#			a.navmesh = NavigationMesh.new()
#			a.navmesh.create_from_mesh(N.mesh)
#			navmesh_add(a, N.transform)
#		if N.get_child_count() > 0:
#			TraceAllMeshes(N)
func HHHHH(from,to):
	var AI_PATH : Array
	get_simple_path(from,to, true)