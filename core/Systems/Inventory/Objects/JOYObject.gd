extends Node
class_name JOYObject

signal empty #emmited when emptied and not broken
signal broken #emmited when breaks

var id : int = 0 # unique object id, 0 for default

var primary_uses : int = 1
var secondary_uses : int = 1
var remain_use_percent : float = 100


# the folloiwing variables handle basic naming and flavor.
var identity : String = "default weapon"
var description : String = "Default description, none has provided yet."

var breaks : bool = false

func set_usage(breaks : bool, uses = 1, remain_use_percent : float = 100):
	self.breaks = breaks
	self.uses = uses
	self.remain_use_percent = remain_use_percent

func restore_uses(_uses : int = 1, secondary : bool = false) -> void:
	if secondary:
		secondary_uses += _uses
	else:
		primary_uses += _uses

func remove_uses(_uses : int = 0, secondary : bool = false) -> void:
	if secondary:
		secondary_uses -= _uses
	else:
		primary_uses -= _uses

func restore_use_percent(percent : float = 1):
	remain_use_percent += percent
	
func secondary_use(_decrease : int = 1) -> void:
	pass

func secondary_release() -> void:
	pass
func primary_use(_times : int = 1) -> void:
	pass

func primary_release() -> void:
	pass

