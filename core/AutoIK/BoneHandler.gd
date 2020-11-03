tool
extends Position3D
class_name BoneHandler

var bone_idx
var bone_attachment : BoneAttachment
var skeleton : Skeleton

func _ready():
	bone_attachment = get_parent()
	skeleton = bone_attachment.get_parent()
	if get_parent() is BoneAttachment:
		for idx in range(0, skeleton.get_bone_count()):
			if get_parent().bone_name == get_parent().get_parent().get_bone_name(idx):
				bone_idx = idx


func _physics_process(delta):
	if skeleton != null:
		skeleton.set_bone_custom_pose(bone_idx, transform)
