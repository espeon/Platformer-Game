class_name PlayerOriginal
extends CharacterBody2D 

@export var main_speed: float = 30
@export var terminal_velocity: float = 300
@export var main_drag: float = 10
@export var gravity: float = 10
@export var jump_velocity: float = 200
@export var start_position: Vector2 = Vector2(160, 50)
@export var max_jumps: int = 2
@export var max_lives: int = 5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationTree = $AnimationTree
@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var crouch_shapecast: ShapeCast2D = $CrouchShapeCast2D
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var standing_cshape = preload("res://assets/collision shapes/player/StandingCollisionShape.tres")
@onready var crouching_cshape = preload("res://assets/collision shapes/player/CrouchCollisionShape.tres")

var speed: float = main_speed
var drag: float = main_drag
var jump_num: int = max_jumps
var lives: int = max_lives
var is_crouching: bool = false
var can_move: bool = true
var stuck_under_object: bool = false
signal win_signal



#this happens onece when load into the screen
func _ready() -> void:
	position = start_position
	anim.active = true


#executes every frame, for non physics processes
func _process(delta) -> void:
	if position.y > 1000:
		$FallDeath.play(0.4)
		lives = max_lives
		position = start_position
		
	#print(position)
	#print(drag)
	#if Input.is_action_just_pressed("die"):
		#win()
	

func hurt() -> void:
	can_move = false
	lives -= 1
	anim.set("parameters/is_alive/transition_request", "hurt") #hurt

func check_life() -> void:
	if lives < 1:
		die()
		return
	$Hurt.play()
	can_move = true
	anim.set("parameters/is_alive/transition_request", "alive") #hurt

func die() -> void:
	$Death.play()
	can_move = false
	anim.set("parameters/is_alive/transition_request", "dead") #die
	
	
func respawn() -> void:
	can_move = true
	lives = max_lives
	anim.set("parameters/is_alive/transition_request", "alive") #alive
	position = start_position
	

func win() -> void:
	$Win.play()
	emit_signal("win_signal")

#executes every frame dealing with physics processes
func _physics_process(delta) -> void:
	#falling mechanics
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > terminal_velocity: #implement terminal velocity
			velocity.y = terminal_velocity
	else:
		jump_num = max_jumps #reset number of jumps if on floor	
	
	
	#jumping mechanics
	if Input.is_action_just_pressed("jump") && jump_num > 0 && !is_crouching && can_move: 
		$Jump.play()
		velocity.y = -jump_velocity
		jump_num -= 1
		jump_particles.angle_max = 0 + 20
		jump_particles.gravity = Vector2(velocity.x / 8, -velocity.y / 8)
		jump_particles.emitting = 1
	
	
	
	#horixontal movement mechanics
	#horizontal direction is between -1 and 1 both or neither is 0
	var horizontal_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left") 
	if can_move:
		velocity.x += speed * horizontal_direction #adds the speed times direction to velocity
		velocity.x -= velocity.x * (drag*delta) 
	else:
		velocity.x = 0
	
	if velocity.x > terminal_velocity: #set terminal velocities
		velocity.x = terminal_velocity
	elif velocity.x < -terminal_velocity:
		velocity.x = -terminal_velocity
		
	if horizontal_direction != 0 && can_move: #flip animation if moving
		switch_direction(horizontal_direction)
	
	
	#crouching mechanics
	if Input.is_action_just_pressed("crouch"):    #crouch
		crouch()
	elif Input.is_action_just_released("crouch"): #attempt to stand
		if above_head_is_empty():
			stand()
		else:
			stuck_under_object = true
	#test if still crouching after being able to stand, then stand 
	if stuck_under_object && !Input.is_action_pressed("crouch") && above_head_is_empty(): 
		stand()
		stuck_under_object = false
	
	
	move_and_slide()
	update_animations(horizontal_direction)

#updates the boolean and collision shape when crouching
func crouch() -> void:
	if !is_crouching:
		is_crouching = true
		speed = 0 #set velocity to 0
		cshape.shape = crouching_cshape
		cshape.position.y = -10.5


#updates the boolean and collision shape when standing
func stand() -> void:
	if is_crouching:
		is_crouching = false
		anim.set("crouch_walk_time", 1) #set the animation speed to normal
		speed = main_speed #set speed to normal
		cshape.shape = standing_cshape
		cshape.position.y = -15

#uses the shapecast to return true if there is nothing on top
func above_head_is_empty() -> bool:
	return !crouch_shapecast.is_colliding()


#updates the corresponding animation in the AnimateSprite2D
func update_animations(horizontal_direction) -> void:
	if is_on_floor():
		anim.set("parameters/in_air_state/transition_request", "ground") #ground
	else:
		anim.set("parameters/in_air_state/transition_request", "air") #air
		$Walk.stop()
	
	if horizontal_direction!=0 && !is_crouching: 
		anim.set("parameters/movement/transition_request", "moving") #moving
		if $Walk.playing == false && is_on_floor():
			$Walk.play()
	else:
		anim.set("parameters/movement/transition_request", "static") #not moving
		$Walk.stop()
		
	if is_crouching:
		anim.set("parameters/static_crouching/transition_request", "crouch") #crouch
		anim.set("parameters/air_crouch/transition_request", "crouch") #air crouch
	else:
		anim.set("parameters/static_crouching/transition_request", "idle") #idle
		anim.set("parameters/air_crouch/transition_request", "air") #no air crouch
		


#flips the animation direction to left or right depending on the direction of movement
func switch_direction(horizontal_direction) -> void: 
	sprite.flip_h = (horizontal_direction < 0) #uses horizontal direction to become a boolean




func _on_skeleton_hurt_player() -> void:
	hurt()
