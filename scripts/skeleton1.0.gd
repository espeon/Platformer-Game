extends CharacterBody2D


@export var normal_speed = 20
@export var chase_speed = 35
@export var direction = 1

@onready var anim = $AnimationPlayer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_chasing = false
var is_attacking = false
var can_hurt = false
signal hurt_player

	

func _physics_process(delta):
	if is_on_floor() && !is_chasing && !is_attacking:
		velocity.x = normal_speed * direction
		anim.play("walk")
		
	else:
		velocity.y += gravity * delta
	
	
	if !$PlatformRayCast2D.is_colliding() || $ObstacleRayCast2D.is_colliding():
		direction *= -1
		scale.x *= -1

	move_and_slide()


func _on_detection_area_body_entered(body):
	if !is_attacking && is_on_floor():
		is_chasing = true
		chase_player(body)


func _on_detection_area_body_exited(body):
	is_chasing = false
	anim.speed_scale = 1

func chase_player(body):	
	if position.x < body.position.x && direction==-1:
		direction *= -1
		scale.x *= -1
	elif position.x > body.position.x && direction==1:
		direction *= -1
		scale.x *= -1
		
	velocity.x = chase_speed * direction
	anim.speed_scale = 1.75
	
	
func _on_damage_area_body_entered(body):
	is_chasing = false
	is_attacking = true
	can_hurt = true
	velocity.x = 0
	anim.play("attack")	


func _on_damage_area_body_exited(body):
	can_hurt = false

func damage_player():
	if can_hurt:
		emit_signal("hurt_player")

func stop_attacking():
	is_attacking = false
	


