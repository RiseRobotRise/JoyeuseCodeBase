extends Component

func _setup():
	actor.BehaviorTree._create_signal("character_entered")
	actor.BehaviorTree._create_signal("character_exited")

func _on_Area_body_entered(body):
	actor.BehaviorTree.emit_signal("character_entered")

func _on_Area_body_exited(body):
	actor.BehaviorTree.emit_signal("character_exited")
