extends Skeleton


func _ready():
	for child in get_children():
		if child is Changer:
			child.rise_handlers()
