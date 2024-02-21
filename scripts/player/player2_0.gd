class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var crouch_shapecast: ShapeCast2D = $CrouchShapeCast2D
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var standing_cshape = preload("res://assets/collision shapes/player/StandingCollisionShape.tres")
@onready var crouching_cshape = preload("res://assets/collision shapes/player/CrouchCollisionShape.tres")

@export var max_lives: int = 5
@export var max_speed: Vector2 = Vector2(300.0, 300.0)
@export var max_crouch_walk_speed: float = 100.0
@export var acceleration: Vector2 = Vector2(3, 10.0)
#@export var 

var horizontal_direction: float = 0
var cur_lives: int = max_lives
var can_move: bool = true
var is_attack_combo: bool = false


enum states {IDLE, RUNNING, CROUCHING, CROUCH_WALK, ROLLING, JUMP, FALL, ATTACK1, ATTACK2, ATTACK3, DEATH, HURT}
var state_functions: Dictionary = {
	states.IDLE : idle_function,
	states.RUNNING : running_function, 
	states.CROUCHING : crouching_function,
	states.CROUCH_WALK : crouch_walking_function,
	states.ROLLING : rolling_function,
	states.JUMP : jump_function, 
	states.FALL : fall_function,
	states.ATTACK1 : attack1_function,
	states.ATTACK2 : attack2_function,
	states.ATTACK3 : attack3_function,
	states.DEATH : death_function,
	states.HURT : hurt_function
}
var cur_state = states.IDLE


func _process(delta):
	print(cur_state, " ", is_attack_combo, " ", anim.current_animation=="attack2")
	#print(horizontal_direction, velocity)
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	if velocity.y!=0:
		cur_state = states.FALL
		return
	#if

func _physics_process(delta):
	state_functions[cur_state].call(delta)
	move_and_slide()
	


#need finish
func idle_function(delta) -> void: 
	#go to conditions
	if horizontal_direction!=0:					#running
		cur_state = states.RUNNING
	if Input.is_action_just_pressed("roll"):	#rolling
		cur_state = states.ROLLING
	if Input.is_action_just_pressed("crouch"):	#crouching
		cur_state = states.CROUCHING
	if Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
		return
	
	velocity.x = lerp(velocity.x, 0.0, acceleration.x*delta)
	anim.play("idle")
	

#need finish
func running_function(delta) -> void: 
	#go to idle
	if horizontal_direction==0:
		cur_state = states.IDLE
	if Input.is_action_just_pressed("crouch"):
		cur_state = states.CROUCH_WALK
	if Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
		return
	
	#logic for movement
	if horizontal_direction!=0 && can_move:
		velocity.x = lerp(velocity.x, max_speed.x*horizontal_direction, acceleration.x*delta)
		sprite.flip_h = (horizontal_direction < 0)
		anim.play("run")
	


#need finish
func crouching_function(delta) -> void:
	if Input.is_action_just_released("crouch"): #logic to stand needed
		cur_state = states.IDLE
	if horizontal_direction!=0:
		cur_state = states.CROUCH_WALK
	
	velocity.x = lerp(velocity.x, 0.0, acceleration.x*delta)
	anim.play("crouch_idle")


#need finish
func crouch_walking_function(delta) -> void:
	if horizontal_direction==0:
		cur_state = states.CROUCHING
	if Input.is_action_just_released("crouch"): #above head needs to be added
		cur_state = states.RUNNING
	
		#logic for movement
	if horizontal_direction!=0 && can_move:
		velocity.x = lerp(velocity.x, max_crouch_walk_speed*horizontal_direction, acceleration.x*delta)
		sprite.flip_h = (horizontal_direction < 0)
		anim.play("crouch_walk")
	



#need finish
func rolling_function(delta) -> void:
	anim.play("roll")
	cur_state = states.IDLE
	pass



#need finish
func jump_function(delta) -> void:
	pass



#need finish
func fall_function(delta) -> void:
	if velocity.y==0:
		cur_state = states.IDLE



#need finish
func attack1_function(delta) -> void:	
	if !anim.current_animation=="attack1" && is_attack_combo: #to attack2
		cur_state = states.ATTACK2
		is_attack_combo = false
		anim.play("attack2")
		return
		
	elif !anim.current_animation=="attack1" && !is_attack_combo: #to idle
		cur_state = states.IDLE
		return
	
	if Input.is_action_just_pressed("attack"): #bool to attack 2
		is_attack_combo = true
	
	#velocity.x = lerp(velocity.x, 0.0, acceleration.x*delta)
	anim.play("attack1")



#need finish
func attack2_function(delta) -> void:
	if !anim.current_animation=="attack2" && is_attack_combo: #to attack3
		cur_state = states.ATTACK3
		is_attack_combo = false
		anim.play("attack3")
		return
	elif !anim.current_animation=="attack2" && !is_attack_combo: #to idle
		cur_state = states.IDLE
	
	if Input.is_action_just_pressed("attack"): #bool to attack 2
		is_attack_combo = true
	
	#velocity.x = lerp(velocity.x, 0.0, acceleration.x*delta)
	anim.play("attack2")



#need finish
func attack3_function(delta) -> void:
	if !anim.current_animation=="attack3": #to idle
		cur_state = states.IDLE
		return
	
	#velocity.x = lerp(velocity.x, 0.0, acceleration.x*delta)
	anim.play("attack3")



#need finish
func hurt_function(delta) -> void:
	if cur_lives<=0:
		cur_state = states.DEATH



#need finish
func death_function(delta) -> void:
	pass



