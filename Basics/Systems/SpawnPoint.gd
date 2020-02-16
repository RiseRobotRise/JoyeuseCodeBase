extends Spatial
class_name SpawnPoint

enum TEAM {
	NO_TEAM,
	PLAYER_TEAM1,
	PLAYER_TEAM2,
	PLAYER_TEAM3,
	PLAYER_TEAM4,
	AI_TEAM1,
	AI_TEAM2,
	AI_TEAM3,
	AI_TEAM4 
	}

export(PackedScene) var Entity
export(bool) var respawns = false
export(int) var lifes = 1 #-1 for infinite
export(TEAM) var team = TEAM.NO_TEAM

var current_instance
var root
#Standard SpawnPoint implementation, use for any type. 



func _ready():
	current_instance = Entity.instance()
	if current_instance is Character:
		root = get_node("/root/World/AI_SH_SYSTEM")
	elif current_instance is RigidBody:
		root = get_node("/root/World")
	

func spawn():
	if lifes > 1:
		root.add_child(current_instance)
