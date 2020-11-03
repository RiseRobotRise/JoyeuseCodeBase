extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var health = 100
var oxygen = 1000
var debug = false
onready var x1 : Control = get_node("VBoxContainer/HBoxContainer/HealthRadar/Container/x1")
onready var x2 : Control = get_node("VBoxContainer/HBoxContainer/HealthRadar/Container/x2")
onready var x3 : Control = get_node("VBoxContainer/HBoxContainer/HealthRadar/Container/x3")
onready var Ox : Control = get_node("VBoxContainer/HBoxContainer/HealthRadar/Container/Oxygen")
export(NodePath) var radarpath = null


func _ready():
	get_node("VBoxContainer/HBoxContainer/HealthRadar/Container/Radar").Ppath = radarpath
	# Called every time the node is added to the scene.
	# Initialization here
	#print(get_viewport().size)
	get_tree().get_root().connect("size_changed", self, "myfunc")
#	scale.x = (get_viewport().size.x/1920)
#	scale.y = (get_viewport().size.y/1080)
	if health >= 101:
		x2.visible = true
	if health >= 201:
		x3.visible = true
	change_health()
	change_oxygen(oxygen)
	
	
func myfunc():
#	scale.x = (get_viewport().size.x/1920)
#	scale.y = (get_viewport().size.y/1080)
	#print("Resizing: ", get_viewport().size)
	pass

func _input(event):
	#print(health)
	#print(oxygen)
	
	if debug == false:
		pass
	elif debug == true:
		if event.is_action_pressed("healthup"):
			if health >= 300:
				health = 300
				pass
			else:
				health += 1
		elif event.is_action_pressed("healthdown"):
			if health <= 0:
				health = 0
				pass
			else:
				health -= 1

		if event.is_action_pressed("oxygenup"):
			if oxygen >= 1000:
				oxygen = 1000
				pass
			else:
				oxygen += 1
		elif event.is_action_pressed("oxygendown"):
			if oxygen <= 0:
				oxygen = 0
				pass
			else:
				oxygen -= 1

	else:
		pass
	
	change_health()
	change_oxygen(oxygen)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_health():
	
	if health >= 1 and health <= 100:
		#get_node("Health|Radar/x1/T_health").interpolate_property(x1,"indicator_value", null ,float(health)/100 ,1.5,Tween.TRANS_LINEAR,Tween.EASE_OUT,0)
		x1.indicator_value = float(health)/100
	elif health <= 0:
		x1.indicator_value = 0
		#get_node("Health|Radar/x1/T_health").interpolate_property(x1,"indicator_value", null ,0  ,1.5,Tween.TRANS_LINEAR,Tween.EASE_OUT,0)
	elif health >= 100:
		x1.indicator_value = 1
		#get_node("Health|Radar/x1/T_health").interpolate_property(x1,"indicator_value", null ,1 ,1.5,Tween.TRANS_LINEAR,Tween.EASE_OUT,0)

	if health >= 101 and health <= 200:
		x2.visible = true
		#get_node("Health|Radar/x2/T_health").interpolate_property(get_node("Health|Radar/x2"),"indicator_value", health ,float(health-100)/100 ,1,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN,0)
		x2.indicator_value = float(health-100)/100
	elif health <= 100:
		#get_node("Health|Radar/x2/T_health").interpolate_property(get_node("Health|Radar/x2"),"indicator_value", health ,0 ,1,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN,0)
		x2.indicator_value = 0
		x2.visible = false
	elif health >= 200:
		#get_node("Health|Radar/x2/T_health").interpolate_property(get_node("Health|Radar/x2"),"indicator_value", health ,1 ,1,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN,0)
		x2.indicator_value = 1 
	if health >= 201 and health <= 300:
		x3.visible = true
		x3.indicator_value = float(health-200)/100
	elif health <= 200:
		x3.indicator_value = 0
		x3.visible = false
	elif health >= 300:
		x3.indicator_value = 1

	if health <= 0:
		x1.indicator_value = 0
		x1.indicator_value = 0
		x3.indicator_value = 0
	pass



func change_oxygen(oxygen):
	if oxygen >= 1 and oxygen <= 1000:
		Ox.indicator_value = float(oxygen)/1000
	elif oxygen <= 0:
		Ox.indicator_value = 0
	elif oxygen >= 1000:
		Ox.indicator_value = 1

	pass
