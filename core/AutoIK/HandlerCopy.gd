tool
extends Position3D
class_name BoneHandler

"""
This class overrides the current pose of a bone with the one set by the target, 
this class along a secondary skeleton can help avoid visual glitches introduced 
in godot 3.2 and also allows for extended functionality. 
"""

export(NodePath) var target
export(NodePath) var pose_match_node : NodePath
export(bool) var use_pose_match : bool = false
var bone_idx
onready var bone_attachment : BoneAttachment = get_parent()
var pose_match : Spatial
var skeleton : Skeleton
var last_transform : Transform = Transform()
func _ready():
	pose_match = get_node(pose_match_node)
	target = get_node(target)
	bone_attachment = get_parent()
	skeleton = bone_attachment.get_parent()
	if get_parent() is BoneAttachment:
		for idx in range(0, skeleton.get_bone_count()):
			if get_parent().bone_name == get_parent().get_parent().get_bone_name(idx):
				bone_idx = idx

func lerp_transform(from : Transform, to : Transform, amount) -> Transform:
	return Transform(lerp(from.basis.x, to.basis.x, amount),
		lerp(from.basis.y, to.basis.y, amount),
		lerp(from.basis.z, to.basis.z, amount),
		lerp(from.origin, to.origin, amount))

func _physics_process(delta):
	if target is Spatial:
		if target.global_transform == Transform.IDENTITY:
			global_transform = last_transform
		else:
			global_transform = target.global_transform
			last_transform = global_transform
	if skeleton != null:
		
		if target.get_parent() is Skeleton:
			if use_pose_match and pose_match != null:
				print(pose_match)
				
				skeleton.set_bone_global_pose_override(bone_idx, lerp_transform( target.get_parent().get_bone_global_pose(bone_idx),pose_match.transform, delta), 1, true)
				
			else:
				skeleton.set_bone_global_pose_override(bone_idx, target.get_parent().get_bone_global_pose(bone_idx), 1, true)#, delta)
		
