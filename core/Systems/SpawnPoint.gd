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

export(PackedScene) var Entity : PackedScene = null
export(bool) var respawns : bool = false
export(int) var lifes : int = 1 #-1 for infinite
export(TEAM) var team : int  = TEAM.NO_TEAM

var current_instance : Node
var root : Node 
#Standard SpawnPoint implementation, use for any type. 



func _ready():
	current_instance = Entity.instance()
	if current_instance is JOYCharacter:
		root = get_node("/root/World/AI_SH_SYSTEM")
	elif current_instance is RigidBody:
		root = get_node("/root/World")
	

func spawn():
	if lifes > 1:
		root.add_child(current_instance)
