extends Spatial
signal sight(objects,points,normals)




func _get_collision_info():
	var objects = []
	var points = []
	var normals = []
	for nodes in get_children():
		objects.append(nodes.get_collider())
		points.append(nodes.get_collision_point())
		normals.append(nodes.get_collision_normal())
	emit_signal("sight",objects,points,normals)

func _is_any_colliding():
	var collides = false
	for nodes in get_children():
		collides = nodes.is_colliding()
		if collides:
			return collides
	return collides

func _process(delta):
	if _is_any_colliding():
		_get_collision_info()
