extends BoneAttachment
class_name Changer
var ready = false


# Called when the node enters the scene tree for the first time.
func rise_handlers():
	for child in get_children():
		remove_child(child)
		get_parent().add_child(child)
		print(child.get_parent())


