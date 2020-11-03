tool
extends SkeletonIK
class_name AutoIK
export(NodePath) var Magnet
func _enter_tree():
	start()



func _process(delta):
	if get_node_or_null(Magnet) != null:
		magnet = get_node(Magnet).translation
