extends Component
signal sight(sight_info)

export(bool) var is_debug : bool = false

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
	actor.BehaviorTree.emit_signal("sight", sight)

func _is_any_colliding():
	var collides = false
	for rays in colliders:
		collides = rays.is_colliding()
		if collides:
			return collides
	return collides

func _setup():
	actor.BehaviorTree._create_signal("sight")
	if not is_debug:
		$DebugShapes.queue_free()

func _process(delta):
	if _is_any_colliding():
		_get_collision_info()

func set_lenght(length : float):
	for child in get_children():
		if child is RayCast:
			child.cast_to = child.cast_to.normalized() * length
