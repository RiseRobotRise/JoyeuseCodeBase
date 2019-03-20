extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Called every time the node is added to the scene.
	Network.connect("connection_failed", self, "_on_connection_failed")
	Network.connect("connection_succeeded", self, "_on_connection_success")
	Network.connect("player_list_changed", self, "refresh_lobby")
	Network.connect("game_ended", self, "_on_game_ended")
	Network.connect("game_error", self, "_on_game_error")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass







######################## MISC ####################################

func refresh_lobby(): #This line of code is used to refresh the Player list (Currently Broken W.I.P.)
	var players = Network.get_player_list()
	var updater = []
	players.sort()
#	get_node("players/list").clear()
#	get_node("players/list").add_item(Network.get_player_info().name + " (You)")
#	for p in players:
#		get_node("players/list").add_item(p.name)
	updater.clear()
	updater.insert(0,Network.get_player_info().name + " (You)")
	for p in players:
		updater.append(p.name)
	#updater.append()

	var playercount = 0

	for m in get_node("PlayerList").get_children():
		if updater[playercount] != null:
			#get_node("PlayerList" + "/" + m.name + "/" + "Name_Tag").set_text = updater[playercount]
			print(updater[playercount])
			playercount += 1
		else:
			break

		#print(m.name)
		#print(updater[playercount])

	#get_node("players/start").disabled = not get_tree().is_network_server()
	pass