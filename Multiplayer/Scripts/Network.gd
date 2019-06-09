extends Node


# [0] Setup for const, signals, and variables before assigning signal connections
# to "_ready()". registered_name is to update "name" at the my_info variable in [2]
# for player list/ nameplate lobby update.

var registered_name = ""

const SERVER_IP = '127.0.0.1'
const SERVER_PORT = 35910
const MAX_PLAYERS = 16

signal player_list_changed()

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")




# [1] Functions to Host or Join a server from the Player Lobby.
# Joining server will send "_connected_ok()" signal to update Player list/ Nametag plates

func _host_game():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	#print(get_tree().is_network_server())

func _join_game(): # If connected, Sends signal to "connected_to_server"/"_connected_ok"
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	#print(get_tree().is_network_server())




#[2] Signals to detect from Godot High-Level Multiplayer API
# that sends executable commands to other online players such as exiting the game
# server shutdowns, etc.

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = registered_name, favorite_color = Color8(255, 0, 255) }

func _player_connected(id):
	pass # Will go unused; not useful here.

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	# Only called on clients, not server. Send my ID and info to all the other peers.
	print("Incoming Player...")
	rpc("register_player", get_tree().get_network_unique_id(), my_info)

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.




# [3] Recieves online executable either from main player or joining player to update
# the playerlist after recieveing the "_connected_ok()" command from [2].

# NOTE: This is currently broken since for some strange reason, while the Server prints
# out the list of joining players, Clients(Joined-Players) will end up printing the same
# list twice, or possibly more. Regardless though, joining the server does still work. Just
# updating the lobby list is currently broken.

remote func register_player(id, info):
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players.
	if get_tree().is_network_server():
		# Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		# Send the info of existing players
		for peer_id in player_info: #For adding Friends to the incoming list
			rpc_id(id, "register_player", peer_id, player_info[peer_id])

	# Call function to update lobby UI here
	#for i in get_node("/root/Main/Main_Menu/PlayerList").get_children():
	#get_node("/root/Main/Main_Menu/PlayerList/Label/Name_Tag").set_text(info.name)
	#get_node("/root/Main/Main_Menu/PlayerList/Label/Plate").self_modulate = info.favorite_color
	emit_signal("player_list_changed")




# [4] Command to tell both the server and rest of the remaining players that a new player is incoming.
# could potentially be upgraded/updated to allow players to join game in-progress, though this is
# not recommended due to possible network errors.

remote func pre_configure_game():
	get_tree().set_pause(true) #Pauses game to sync the world and player setup [OPTIONAL]
	var selfPeerID = get_tree().get_network_unique_id()

	# Load world
	var world = load("res://Level.tscn").instance()
	get_node("/root").add_child(world)

	# Load my player
	var my_player = load("res://Objects/player.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/world/players").add_child(my_player)

	# Load other players
	for p in player_info:
		var player = load("res://Objects/player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		get_node("/root/world/players").add_child(player)

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	rpc_id(1, "done_preconfiguring", selfPeerID)



var players_done = []
remote func done_preconfiguring(who):
    # Here are some checks you can do, for example
    assert(get_tree().is_network_server())
    assert(who in player_info) # Exists
    assert(not who in players_done) # Was not added yet

    players_done.append(who)

    if players_done.size() == player_info.size():
        rpc("post_configure_game")

remote func post_configure_game():
    get_tree().set_pause(false)
    # Game starts now!





########## MISC ######################
# [5] Additonal functions for part of updating Player Lobby, finding nametags. etc...

func get_player_list(): #Part of refreshing Lobby List
	return player_info.values()

func get_player_info(): #Part of refreshing Lobby List
	return my_info

func name_update(n):
	registered_name = n