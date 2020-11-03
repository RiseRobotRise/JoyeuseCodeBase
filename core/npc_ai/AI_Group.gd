extends Spatial
class_name JOYAIAbstraction

"""
This class is an abstraction of AI, must be used for controlling groups of AI or 
a single AI character, this can also be extended to allow various behaviors and 
routes. Currently extends an existing steering framework. 
"""
var coordinated_agents : Array = []




#------------------------------------


func setup_agent(node : JOYCharacter):
	var agent := GSAIKinematicBody3DAgent.new(node)
	agent.linear_speed_max = node.max_speed
	agent.linear_acceleration_max = node.aceleration_max
	agent.angular_speed_max = deg2rad(node.angular_speed_max)
	agent.angular_acceleration_max = deg2rad(node.angular_acceleration_max)
	agent.bounding_radius = node.get_collision_shape_radius
#	update_agent()
# Maximum possible linear velocity
	var speed_max := 450.0
# Maximum change in linear velocity
	var acceleration_max := 50.0
# Maximum rotation velocity represented in degrees
	var angular_speed_max := 240
# Maximum change in rotation velocity represented in degrees
	var angular_acceleration_max := 40
	var health_max := 100
	var flee_health_threshold := 20
	var velocity := Vector2.ZERO
	var angular_velocity := 0.0
	var linear_drag := 0.1
	var angular_drag := 0.1
# Holds the linear and angular components calculated by our steering behaviors.
	var acceleration := GSAITargetAcceleration.new()
	var current_health := health_max
	# GSAISteeringAgent holds our agent's position, orientation, maximum speed and acceleration.
	var player: Node = get_tree().get_nodes_in_group("Player")[0]
# This assumes that our player class will keep its own agent updated.
	var player_agent: GSAISteeringAgent = player.agent
# GSAIBlend combines behaviors together, calculating all of their acceleration together and adding
# them together, multiplied by a strength. We will have one for fleeing, and one for pursuing,
# toggling them depending on the agent's health. Since we want the agent to rotate AND move, then
# we aim to blend them together.
	var flee_blend := GSAIBlend.new(agent)
	var pursue_blend := GSAIBlend.new(agent)
# GSAIPriority will be the main steering behavior we use. It holds sub-behaviors and will pick the  
# first one that returns non-zero acceleration, ignoring any afterwards.
	var priority := GSAIPriority.new(agent)
# Proximities represent an area with which an agent can identify where neighbors in its relevant
# group are. In our case, the group will feature the player, which will be used to avoid a
# collision with them. We use a radius proximity so the player is only relevant inside 100 pixels
	var proximity := GSAIRadiusProximity.new(agent, [player_agent], 100)
	
##################Compiled behavior############################

func _ready():
	for child in get_children():
		if child is JOYCharacter:
			setup_agent(child)
			get_parent()._register_ai_actor(child)

func _unregister_ai_actor(node : JOYCharacter):
	get_parent()._unregister_ai_actor(node)
