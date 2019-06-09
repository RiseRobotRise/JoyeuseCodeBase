class_name Player
extends MovableKinematic
var current_state = 0 
enum {
	IDLE = 1,
	WALK = 2,
	RUN = 3,
	COMBAT = 4,
	DEAD = 6
}
export(PackedScene) var Gun
func _ready():
	team = 1
	current_state = IDLE
	pass # Replace with function body.

