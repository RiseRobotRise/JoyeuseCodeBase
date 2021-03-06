class_name RAD
static func map(x, in_min, in_max, out_min, out_max):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
#Usage:  val = map(val, 0, 1023, 0, 255)



static func randv(vector:Vector3):
	return Vector3(
		rand_range(-vector.x,vector.x),
		rand_range(-vector.y,vector.y),
		rand_range(-vector.z,vector.z)
		)


static func rotation_from_to(A,B):
	var output=Vector3()
	output.x=rad2deg(atan2((B.y-A.y),(B.z-A.z)))
	output.y=rad2deg(atan2((B.z-A.z),(B.x-A.x)))
	output.z=rad2deg(atan2((B.y-A.y),(B.x-A.x)))
	return output
#Returns a Vector3 containing cilindircal relative coordinates.
#Both Coordinates must be the same type (either local or global)


static func adjust_facing(p_facing, p_target, p_step, p_adjust_rate, current_gn):
	var n = p_target # Normal
	var t = n.cross(current_gn).normalized()

	var x = n.dot(p_facing)
	var y = t.dot(p_facing)

	var ang = atan2(y,x)

	if (abs(ang) < 0.001): # Too small
		return p_facing

	var s = sign(ang)
	ang = ang*s
	var turn = ang*p_adjust_rate*p_step
	var a
	if (ang < turn):
		a = ang
	else:
		a = turn
	ang = (ang - a)*s

	return (n*cos(ang) + t*sin(ang))*p_facing.length()
	

static func _get_object_info(object:Node):
	var propetries = {}
	if object.has_method("get_global_transform"):
		if object is StaticBody:
			return
		else:
			propetries = {
				"position" : object.translation,
				"type" : object.type,
				"health" : object.health,
				"team" : object.team
				 }
			return propetries.values()
			
static func debug_print(what):
	print(what)
