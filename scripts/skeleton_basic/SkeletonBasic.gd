class_name Skeleton
extends CharacterBody2D

@export var main_speed: float			= 30.0
@export var chase_speed: float			= 40.0
@export var terminal_velocity: float	= 300.0
@export var main_drag: float 			= 10.0
@export var gravity: float				= 10.0
@export var jump_velocity: float		= 200.0
@export var start_position: Vector2		= Vector2(160, 50)
@export var direction: float			= -1.0
@export var is_walker: bool				= true
@export var is_chasing: bool			= false
@export var is_attacking: bool			= false
@export var player_in_attack_range: bool= false
@export var health: int					= 2

@onready var sprite: AnimatedSprite2D	= $AnimatedSprite2D
@onready var anim: AnimationTree		= $AnimationTree
@onready var cshape: CollisionShape2D	= $CollisionShape2D

#this happens once when load into the screen
func _ready() -> void:
	position = start_position
	if !is_walker:
		main_speed  = 0.0
		chase_speed = 0.0
	anim.active = true

#executes every frame, for non physics processes
func _process(delta) -> void:
	pass

func _physics_process(delta):
	# deal with walking/chasing processes
	if is_on_floor():
		if is_walker:
			if !is_attacking:
				anim.play("walk")
				if is_chasing:
					velocity.x = chase_speed * direction
				else:
					velocity.x = main_speed * direction
				move_and_slide()
		elif !is_attacking:
				anim.play("stand")
	else:
		velocity.y += gravity * delta
	
	# deal with edge & wall detection
	if !$EdgeRaycast.is_colliding() && $WallRaycast.is_colliding():
		direction *= -1.0
		scale.x   *= -1.0
	
func die():
	anim.play("death")
	pass

func _on_player_detection_area_body_entered(body):
	if is_walker && !is_attacking && is_on_floor():
		is_chasing = true
		start_chasing_player(body)

func start_chasing_player(body):
	if position.x < body.position.x:
		direction = 1.0
		scale.x   = 1.0
	if position.x > body.position.x:
		direction = -1.0
		scale.x   = -1.0
	velocity.x = chase_speed * direction
	if is_walker:
		anim.speed_scale = 1.75
		anim.play("walk")
	return

func _on_player_detection_area_body_exited(body):
	is_chasing = false
	anim.speed_scale = 1.00
	return

func _on_body_hurtbox_body_entered(body):
	pass	# if is instance of Player's attack hitbox
	if is_instance_of(body, Player):
		# hurt player or get hurt by player
		pass
	return

func hurt():
	if health == 0:
		anim.play("die")
		# implement death process here
	else:
		anim.play("hurt")
		# implement hurt process here
	return

func _on_attack_hitbox_body_entered(body):
	is_attacking           = true
	player_in_attack_range = true
	velocity.x             = 0.0
	anim.play("attack")
	return

func _on_attack_hitbox_body_exited(body):
	player_in_attack_range = false
	return

func damage_player():
	if player_in_attack_range:
		emit_signal("hurt_player")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
