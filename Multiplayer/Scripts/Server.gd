extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAX_PLAYERS = 4
var SERVER_PORT = 3591

# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	get_tree().is_network_server()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().set_network_peer(null)
		var loader = load("res://Main_Menu.tscn").instance()
		get_node("/root/Main")
		self.queue_free()