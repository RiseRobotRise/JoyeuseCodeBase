extends Node
class_name Decoder
"""
Takes nodes and returns structured static information, useful to use as 
networked packages. 
"""

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
static func get_object_info(object : Node):
	pass
