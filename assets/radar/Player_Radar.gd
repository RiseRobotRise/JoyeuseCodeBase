tool
extends Control
var E_icon = preload("../ui/Enemy.tscn")
var P_icon 
export(NodePath) var Ppath = null
var E_Area
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var circle_size = 1

func _ready():
	
	#E_Area = get_tree().get_root().get_node("Area")
	#E_Area.connect("body_entered", self, "on_body_entered")
	#E_Area.connect("body_exited", self, "on_body_exit")
	#update()
	#draw_circle(Vector2(0,0),20,Color(1,1,1,1))
	pass
	

func _draw():
	draw_circle(Vector2(circle_size/2,circle_size/2),circle_size/2,Color(0,0,0,.2))
	$Blur.draw_circle(Vector2(circle_size/2,circle_size/2),circle_size/2,Color(0,0,0,.2))

func _on_body_entered(body):
	#if body.has_group("Enemy"):
	var Instanced = E_icon.instance()
	Instanced.name = str(body)
	Instanced.position = rect_position
	Instanced.represents = body
	Instanced.parentarea = E_Area
	add_child(Instanced)
	print("Icon created")
		
func _on_body_exit(body):
	if body.is_in_group("Enemy") or body.is_in_group("Ally") or body.is_in_group("Player"): 
		find_node(str(body)).queue_free()
	
	
	
func _on_Radar_item_rect_changed():
	if get_rect().size.x > get_rect().size.y:
		circle_size = get_rect().size.y
	elif get_rect().size.x < get_rect().size.y:
		circle_size = get_rect().size.x
	else:
		if circle_size != get_rect().size.x and circle_size != get_rect().size.y:
			circle_size = get_rect().size.x
		else:
			circle_size = circle_size
	
