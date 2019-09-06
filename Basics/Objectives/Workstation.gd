extends KinematicBody
class_name Workstation, "../../icons/workstation.png"

export(float) var health = 100
export(float) var progress_p_sec = 1 
export(bool)  var degrades_with_time = false
export(float) var degradation = 0
export(bool)  var perma_death = true
export(bool)  var inmortal = false

var available = true

signal unusable(idx,something, something)
signal just_fully_repaired()
signal just_destroyed()

func _ready():
	var timer = Timer.new()
	timer.name = "delay"
	timer.time_left = 0.5
	timer.autostart = false
	timer.connect("timeout",self,"on_timer")
	self.add_child(timer)
	if degrades_with_time:
		var timer2 = Timer.new()
		timer2.name = "damage"
		timer2.time_left = 1
		timer2.autostart = true
		timer2.connect("timeout",self,"on_damage_timer")
		self.add_child(timer2)
		

func on_timer():
	available = not available

func on_damage_timer():
	health = health - degradation
	
func damage(mult = 1):
	$delay.start()
	if available:
		health -= progress_p_sec*mult
	
func repair(mult = 1):
	$delay.start()
	if available:
		health += progress_p_sec*mult
