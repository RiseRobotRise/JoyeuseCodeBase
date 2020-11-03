extends Component
signal sight(sight_info)

var colliders : Array = []

func _ready():
	for rays in get_children():
		if rays is RayCast:
			colliders.append(rays) 

func _get_collision_info():
	var sight : Dictionary= {}
	var objects : Array = []
	var points : Array = []
	var normals : Array = []
	for ray in colliders:
		objects.append(ray.get_collider())
		points.append(ray.get_collision_point())
		normals.append(ray.get_collision_normal())
	sight["objects"] = objects
	sight["points"] = points
	sight["normals"] = normals
	emit_signal("sight", sight)

func _is_any_colliding():
	var collides = false
	for rays in colliders:
		collides = rays.is_colliding()
		if collides:
			return collides
	return collides

func _process(delta):
	if _is_any_colliding():
		_get_collision_info()
