extends SkeletonState

@export var _animation_player = NodePath()
@onready var animation_player: AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}):
	if player.is_walker:
		state_machine.transition_to("StateRoam")
		return
	player.velocity = Vector2(0.0, 0.0)
	animation_player.play("Idle")

