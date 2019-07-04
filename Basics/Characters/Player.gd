extends Character
class_name Player, "res://icons/player.png"

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
	type = "Player"
	team = 1
	current_state = IDLE
	pass # Replace with function body.

