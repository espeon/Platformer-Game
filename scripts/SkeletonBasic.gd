class_name Skeleton
extends CharacterBody2D

@export var main_speed: float			= 30.0
@export var chase_speed: float			= 50.0
@export var terminal_velocity: float	= 300.0
@export var main_drag: float 			= 10.0
@export var gravity: float				= 10.0
#@export var jump_velocity: float		= 200.0
#@export var start_position: Vector2	= Vector2(160, 50)
@export var direction: float			= 1.0
#@export var is_walker: bool				= true
var sees_player: bool					= false
var is_attacking: bool					= false
var player_in_attack_range: bool		= false
@export var health: int					= 2
var anim_is_playing: bool				= false
var current_anim: String				= ""
var player_object						= null

@onready var anim: AnimatedSprite2D		= $AnimatedSprite2D
@onready var cshape: CollisionShape2D	= $CollisionShape2D

#this happens once when load into the screen
func _ready() -> void:
	set_anim("walk")
	return

#executes every frame, for non physics processes
func _process(delta) -> void:
	return

func set_anim(animname: String) -> void:
	if current_anim != "attack": # || !anim_is_playing:
		print("running function [set_anim], animname=", animname)
		current_anim = animname
		anim.play(animname)
		anim_is_playing = true
	return

func _physics_process(delta):
	# deal with walking/chasing processes
	if is_on_floor() && !is_attacking:
		if sees_player:
			velocity.x = chase_speed * direction
		else:
			velocity.x = main_speed * direction
		move_and_slide()
		
	if !is_on_floor():
		velocity.y += gravity
		move_and_slide()
	
	# deal with edge & wall detection
	if !$EdgeRaycast.is_colliding() || ($WallRaycast.is_colliding() && is_on_floor()):
		direction  *= -1.0
		scale.x    *= -1.0
	
	
func die():
	print("running function [die]")
	set_anim("death")
	pass

func _on_player_detection_area_body_entered(body):
	#print("running function [_on_player_detection_area_body_entered], body=", body)
	if body.name == "Player":
		player_object = body
		sees_player   = true

func _on_player_detection_area_body_exited(body):
	#print("running function [_on_player_detection_area_body_exited], body=", body)
	if body.name == "Player":
		sees_player = false
	return


#func _on_body_hurtbox_body_entered(body):
	#pass	# if is instance of Player's attack hitbox
	#if is_instance_of(body, Player):
		# hurt player or get hurt by player
		#pass
	#return

func hurt():
	#print("running function [hurt]")
	if health == 0:
		set_anim("death")
		# implement death process here
	else:
		set_anim("hurt")
		health -= 1
		# implement hurt process here
	return

## When the player enters the attack-trigger range, start the attack animation.
func _on_attack_range_box_body_entered(body):
	#print("running function [_on_attack_range_box_body_entered], body=", body)
	if body.name == "Player":
		is_attacking = true
		#anim.speed_scale = 1.00
		set_anim("attack")
	return

## When the player enters the attack's hitbox, set a boolean TRUE.
func _on_attack_hitbox_body_entered(body):
	print("running function [_on_attack_hitbox_body_entered], body=", body)
	if body.name == "Player":
		player_in_attack_range = true
		hurt_player()
	return

## When the player exits the attack's hitbox, set a boolean TRUE.
func _on_attack_hitbox_body_exited(body):
	if body.name == "Player":
		player_in_attack_range = false
	return

## Called during the "attack" animation.
func hurt_player():
	print(player_object, " is the player object")
	if player_in_attack_range:
		player_object.hurt()
	return

func _on_animation_player_animation_finished(anim_name):
	print("running function [_on_animation_player_animation_finished], anim_name=", anim_name)
	if anim_name == "attack":
		is_attacking = false
	anim_is_playing = false
		#set_anim("walk")
