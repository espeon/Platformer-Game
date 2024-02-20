class_name Player
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var crouch_shapecast: ShapeCast2D = $CrouchShapeCast2D
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var standing_cshape = preload("res://assets/collision shapes/player/StandingCollisionShape.tres")
@onready var crouching_cshape = preload("res://assets/collision shapes/player/CrouchCollisionShape.tres")

var horizontal_direction: float = 0


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
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if velocity.y!=0:
		cur_state = states.FALL
	

func _physics_process(delta):
	state_functions[cur_state].call()
	


#need finish
func idle_function() -> void: 
	#go to conditions
	if horizontal_direction!=0:					#running
		cur_state = states.RUNNING
	if Input.is_action_just_pressed("roll"):	#rolling
		cur_state = states.ROLLING
	if Input.is_action_just_pressed("crouch"):	#crouching
		cur_state = states.CROUCHING
	if Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
	
	anim.play("idle")
	

#need finish
func running_function() -> void: 
	#go to idle
	if horizontal_direction==0:
		cur_state = states.IDLE
	
	#logic for later
	anim.play("run")


#need finish
func crouching_function() -> void:
	if Input.is_action_just_released("crouch"): #logic to stand needed
		cur_state = states.IDLE
	if horizontal_direction!=0:
		cur_state = states.CROUCH_WALK
	


#need finish
func crouch_walking_function() -> void:
	if horizontal_direction==0:
		cur_state = states.CROUCHING
	if Input.is_action_just_released("crouch"):
		cur_state = states.RUNNING



#need finish
func rolling_function() -> void:
	#anim.play("roll")
	cur_state = states.IDLE
	pass



#need finish
func jump_function() -> void:
	pass



#need finish
func fall_function() -> void:
	pass



#need finish
func attack1_function() -> void:
	cur_state = states.IDLE
	anim.play("attack1")
	#need to figure how to sync the end of animation with switching
	#make a global bool variable attack_pressed that stays on here and if state
	#in idle turns it off woala!
	#if attack_pressed:
	#	cur_state = states.ATTACK2



#need finish
func attack2_function() -> void:
	cur_state = states.IDLE
	anim.play("attack2")
	#need to figure how to sync the end of animation with switching
	#make a global bool variable attack_pressed that stays on here and if state
	#in idle turns it off woala!
	#if attack_pressed:
	#	cur_state = states.ATTACK3



#need finish
func attack3_function() -> void:
	cur_state = states.IDLE
	anim.play("attack3")
	#need to figure how to sync the end of animation with switching to go back to idle




#need finish
func death_function() -> void:
	pass



#need finish
func hurt_function() -> void:
	pass




