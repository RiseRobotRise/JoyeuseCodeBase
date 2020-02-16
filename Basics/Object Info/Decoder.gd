extends Node
enum OBJECT_TYPE {
	NULL = -1,
	CHARACTER = 0,
	BULLET = 1,
	MISC = 2
}
var projectile_structure_template : Dictionary = {
	"owner_id" : 0,
	"team" : 0,
	"type" : OBJECT_TYPE.BULLET,
	"position" : Vector3(),
	"rotation" : Vector3(),
	"damage" : 1
}
