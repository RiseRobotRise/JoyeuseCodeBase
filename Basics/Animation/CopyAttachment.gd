tool
extends BoneAttachment

export(NodePath) var Target 
var reference : Spatial
var bone_idx : int = 0
var target_skeleton : Skeleton
onready var current_skeleton : Skeleton = get_parent()
func _ready():
	reference = get_node_or_null(Target)
	for bones in range(0, current_skeleton.get_bone_count()):
		if current_skeleton.get_bone_name(bones) == bone_name:
			bone_idx = bones
	if reference!= null:
		target_skeleton = reference.get_parent()

func _process(delta):
#	parent.set_bone_custom_pose(bone_idx, reference.transform)
	get_parent().set_bone_global_pose_override(bone_idx, reference.get_parent().get_bone_global_pose(bone_idx),1,false)
	
