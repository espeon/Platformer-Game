class_name Player
extends CharacterBody2D
#get_tree().quit()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var crouch_shapecast: ShapeCast2D = $CrouchShapeCast2D
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var standing_cshape = preload("res://assets/collision shapes/player/StandingCollisionShape.tres")
@onready var crouching_cshape = preload("res://assets/collision shapes/player/CrouchCollisionShape.tres")
var pixel_scale: float = 0.55 #fix the scaling, somehow the pixels are not exacly by 0.5 

@export var max_lives: int = 5
@export var max_jump_num: int = 2

var max_speed: Vector2 = Vector2(600.0, 600.0)*pixel_scale
var max_crouch_walk_speed: float = 100.0*pixel_scale
var max_roll_speed: float = 600.0*pixel_scale
var speed_time_to_peak: float = 0.5
var speed_time_to_stop: float = 0.2


var horizontal_direction: float = 0
var jump_num: int = max_jump_num
var cur_lives: int = max_lives
var can_move: bool = true
var is_attack_combo: bool = false
var is_jumping: bool = false

var jump_height : float = 50*pixel_scale
var jump_time_to_peak : float = 0.4
var jump_time_to_descent : float = 0.3

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) / pow(jump_time_to_peak,2)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) / pow(jump_time_to_descent,2)) * -1.0


enum states {IDLE, RUNNING, CROUCHING, CROUCH_WALK, ROLLING, JUMP, ATTACK1, ATTACK2, ATTACK3, FALL, HURT, DEATH}
var state_functions: Dictionary = {
	states.IDLE : idle_function,
	states.RUNNING : running_function, 
	states.CROUCHING : crouching_function,
	states.CROUCH_WALK : crouch_walking_function,
	states.ROLLING : rolling_function,
	states.JUMP : jump_function, 
	states.ATTACK1 : attack1_function,
	states.ATTACK2 : attack2_function,
	states.ATTACK3 : attack3_function,
	states.FALL : fall_function,
	states.HURT : hurt_function,
	states.DEATH : death_function
}
var cur_state = states.IDLE


func _process(delta):
	print(cur_state, " ", max_speed.x, " ", velocity.x, " ")
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	

func _physics_process(delta):
	state_functions[cur_state].call(delta)
	if !is_on_floor() && !is_jumping:				#falling logic universal
		cur_state = states.FALL
	move_and_slide()
	
	

func get_gravity() -> float:
	if velocity.y<0:
		return jump_gravity
	else:
		return fall_gravity

func move(delta) -> void:
	if cur_state==states.CROUCH_WALK:
		velocity.x = move_toward(velocity.x, max_crouch_walk_speed*horizontal_direction, speed_time_to_peak)
	else:
		velocity.x = move_toward(velocity.x, max_speed.x*horizontal_direction, speed_time_to_peak)
	sprite.flip_h = (horizontal_direction < 0)

func stop(delta) -> void:
	velocity.x = move_toward(velocity.x, 0.0, speed_time_to_stop)

func get_sprite_direction() -> int:
	if sprite.flip_h:	#if right returns 1
		return -1
	else:
		return 1

func jump(delta):
	is_jumping = true
	cur_state = states.JUMP
	jump_num -= 1
	velocity.y = jump_velocity

#need finish
func idle_function(delta) -> void: 
	#go to conditions
	if horizontal_direction!=0:									#running
		cur_state = states.RUNNING
	elif Input.is_action_just_pressed("roll"):					#rolling
		cur_state = states.ROLLING
		velocity.x = max_roll_speed*get_sprite_direction()
		anim.play("roll")
	elif Input.is_action_just_pressed("crouch"):				#crouching
		cur_state = states.CROUCHING
	elif Input.is_action_just_pressed("jump") && jump_num>0:	#jumping
		jump(delta)
	elif Input.is_action_just_pressed("attack"):				#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
	else:
		stop(delta)
		anim.play("idle")
	

#need finish
func running_function(delta) -> void: 
	#go to idle
	if horizontal_direction==0:						#idle
		cur_state = states.IDLE
	elif Input.is_action_just_pressed("crouch"):	#crouch_walk
		cur_state = states.CROUCH_WALK
	elif Input.is_action_just_pressed("roll"):		#roll
		cur_state = states.ROLLING
		velocity.x = max_roll_speed*get_sprite_direction()
		anim.play("roll")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump(delta)
	elif Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
	elif can_move: 									#logic for movement
		move(delta)
		anim.play("run")
	


#need finish
func crouching_function(delta) -> void:
	if Input.is_action_just_released("crouch"): 	#idle #logic to stand needed
		cur_state = states.IDLE
	elif horizontal_direction!=0:					#crouch_walk
		cur_state = states.CROUCH_WALK
	elif Input.is_action_just_pressed("roll"):		#roll
		cur_state = states.ROLLING
		velocity.x = max_roll_speed*get_sprite_direction()
		anim.play("roll")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump(delta)
	elif Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
	else:
		stop(delta)
		anim.play("crouch_idle")


#need finish
func crouch_walking_function(delta) -> void:
	if Input.is_action_just_released("crouch"): 	#run #above head needs to be added
		cur_state = states.RUNNING
	elif horizontal_direction==0:					#crouch
		cur_state = states.CROUCHING
	elif Input.is_action_just_pressed("roll"):		#roll
		cur_state = states.ROLLING
		velocity.x = max_roll_speed*get_sprite_direction()
		anim.play("roll")
	elif Input.is_action_just_pressed("jump"):		#jump
		jump(delta)
	elif Input.is_action_just_pressed("attack"):	#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
	elif can_move: 									#logic for movement
		move(delta)
		anim.play("crouch_walk")
	



#need finish
func rolling_function(delta) -> void:
	if !anim.current_animation=="roll":
		cur_state = states.IDLE
	else:
		stop(delta)



#need finish
func attack1_function(delta) -> void:
	if !anim.current_animation=="attack1" && is_attack_combo: #to attack2
		cur_state = states.ATTACK2
		is_attack_combo = false
		anim.play("attack2")		
	elif !anim.current_animation=="attack1" && !is_attack_combo: #to idle
		cur_state = states.IDLE
	else:
		stop(delta)
		anim.play("attack1")
		
		if Input.is_action_just_pressed("attack"): #bool to attack 2
			is_attack_combo = true



#need finish
func attack2_function(delta) -> void:
	if !anim.current_animation=="attack2" && is_attack_combo: #to attack3
		cur_state = states.ATTACK3
		is_attack_combo = false
		anim.play("attack3")
	elif !anim.current_animation=="attack2" && !is_attack_combo: #to idle
		cur_state = states.IDLE
	else:
		stop(delta)
		anim.play("attack2")
		
		if Input.is_action_just_pressed("attack"): #bool to attack 2
			is_attack_combo = true



#need finish
func attack3_function(delta) -> void:
	if !anim.current_animation=="attack3": #to idle
		cur_state = states.IDLE
	else:
		stop(delta)
		anim.play("attack3")



#need finish
func jump_function(delta) -> void:
	if Input.is_action_just_pressed("attack"):						#attack1
		is_jumping = false
		cur_state = states.ATTACK1
		anim.play("attack1")
	elif Input.is_action_just_pressed("jump") && jump_num>0:		#double jump
		jump(delta)
	elif !anim.current_animation=="jump":							#fall
		is_jumping = false
		cur_state = states.FALL
	else:															#upwards logic
		move(delta)
		velocity.y += get_gravity() * delta
		anim.play("jump")
	
	
	
	
	
	#if velocity.y>0:														#falling
		#is_jumping = false
		#cur_state = states.FALL
	#elif jump_num>0 && Input.is_action_just_pressed("jump"):				#double jump
		#is_jumping = true
		#velocity.y = jump_velocity
		#jump_num -= 1
	#elif Input.is_action_just_pressed("attack"):							#attack1
		#is_jumping = false
		#cur_state = states.ATTACK1
		#anim.play("attack1")
	#elif velocity.y<0: 														#jump logic
		#is_jumping = true
		#move(delta)
		#velocity.y += get_gravity() * delta
		#anim.play("jump")



#need finish
func fall_function(delta) -> void:
	if is_on_floor():											#idle
		cur_state = states.IDLE
		jump_num = max_jump_num
	elif Input.is_action_just_pressed("attack"):				#attack1
		cur_state = states.ATTACK1
		anim.play("attack1")
	elif Input.is_action_just_pressed("jump") && jump_num>0:	#double jump
		jump(delta)
	elif !is_on_floor():											#falling logic
		move(delta)
		velocity.y += get_gravity() * delta
		if velocity.y>max_speed.y:
			velocity.y = max_speed.y
		anim.play("falling")



#need finish
func hurt_function(delta) -> void:
	if cur_lives<=0:
		cur_state = states.DEATH



#need finish
func death_function(delta) -> void:
	pass



