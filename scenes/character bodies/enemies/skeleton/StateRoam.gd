extends SkeletonState

@export var _animation_player = NodePath()
@onready var animation_player: AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}):
	if not player.is_walker:
		state_machine.transition_to("StateStand")
		return

func _physics_process(delta):
	if player.is_on_floor():
		player.velocity.x = player.main_speed * player.direction
	if !$PlatformRayCast2D.is_colliding() || $ObstacleRayCast2D.is_colliding():
		player.direction *= -1
		player.scale.x *= -1
	player.move_and_slide()
	
func _process(delta):
	pass
	
