extends Area
class_name JOYWorkstation, "../../icons/workstation.png"

"""
Base class  for the NPC Interactors, namely Workstations. 
This class contains methods that must be overriden. 
"""
enum CATEGORY {
	WORK, 
	FOOD,
	ENTERTAINMENT,
	PERSON,
	OTHERS
}



onready var pos = $NPCPosition

export(float) var health = 100
export(float) var progress_p_sec = 1 
export(bool)  var degrades_with_time = false
export(float) var degradation = 0
export(bool)  var perma_death = true
export(bool)  var inmortal = false

var available = true

var progress : float = 0.0
var in_queue_for_use : Array = []
var current_worker : Worker = null
var lookdir : Vector3 = Vector3.ZERO
var position : Vector3 = Vector3.ZERO
export(bool) var usable_by_players = false
export(bool) var uses_queue : bool = false
export(bool) var call_best_first : bool = false
export(bool) var gives_xp : bool = false
export(int) var maximum_progress : int = 10
export(bool) var is_available : bool = true
export(CATEGORY) var category : int = CATEGORY.WORK
export(String) var subcategory : String = ""
export(Array, NodePath) var Exclude : Array = []

signal unusable(idx,something, something)
signal just_fully_repaired()
signal just_destroyed()


func _enter_tree() -> void:
	add_to_group("Workstations")
	connect("body_entered", self, "_on_body_entered")
	set_active(true)

func _ready() -> void:
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
	
	if not usable_by_players:
		set_active(false)
		set_collision_mask_bit(16, true)
		set_collision_layer_bit(16, true)
	for path in Exclude:
		if path is Object:
			continue
		else:
			Exclude.append(get_node(path))
			Exclude.erase(path)
	if pos:
		position = get_parent().to_local(to_global(pos.translation))
		lookdir = (translation - pos.translation)/2
		
func set_active(toggle : bool):
	if toggle:
		is_available = true
	else:
		is_available = false

func check_for_next() -> void:
	progress = 0
	if not uses_queue:
		return
	if call_best_first:
		assign(select_best_from_queue())
	else:
		assign(select_neareast())
	
func do_work(amount: float, experience : float) -> float:
	progress += (amount + 1 * experience)/100
	print(progress)
	if progress >= maximum_progress:
		is_available = true
		current_worker.stop_working(category)
		check_for_next()
	if gives_xp:
		return amount/100
	return 0.0

func select_best_from_queue() -> Worker:
	var best_worker : Worker = null
	if in_queue_for_use.size() < 1:
		return null
	best_worker = in_queue_for_use[0]
	for worker in in_queue_for_use:
		if worker.experience > best_worker.experience:
			best_worker = worker
	return best_worker
	
func select_neareast() -> Worker:
	var nearest_worker : Worker = null
	if in_queue_for_use.size() < 1:
		return null
	nearest_worker = in_queue_for_use[0]
	for worker in in_queue_for_use:
		if (worker.entity.translation - translation).length() < (nearest_worker.entity.translation - translation).length():
			nearest_worker = worker
	return nearest_worker

func assign(worker : Worker) -> void:
	if worker == null:
		return
	is_available = false
	current_worker = worker
	worker.emit_signal("workstation_assigned", position)

func request_workstation(worker : Worker) -> bool:
	print("Workstation: request recived from ", worker)
	if get_parent() is JOYCharacter:
		if get_parent().get_component("AI handler") != null:
			if get_parent().get_component("AI handler").worker == worker:
				return false
	if uses_queue:
		in_queue_for_use.append(worker)
		return true
	elif is_available:
		assign(worker)
		return true
	else:
		print("Busy!")
		return false

func _on_body_entered(entity) -> void:
	print("A worker arrived!")
	if entity == get_parent():
		return
	var worker : Worker = entity.get_component("AI handler").worker
	if worker:
		if worker == current_worker:
			entity.get_component("NPCInput").get_navpath(translation)
			print("The worker has arrived")
			worker.start_working(self)
			_change_state_on_user(worker)
			
func _change_state_on_user(worker : Worker):
	#This is meant for changing animation states, so it changes depending on the 
	#type of workstation
	pass

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
