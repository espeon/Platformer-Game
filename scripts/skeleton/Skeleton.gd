class_name Skeleton
extends CharacterBody2D

@export var main_speed: float = 30
@export var chase_speed: float = 40
@export var terminal_velocity: float = 300
@export var main_drag: float = 10
@export var gravity: float = 10
@export var jump_velocity: float = 200
@export var start_position: Vector2 = Vector2(160, 50)
@export var is_walker = true
@export var direction: float = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationTree = $AnimationTree
@onready var cshape: CollisionShape2D = $CollisionShape2D
@onready var state_machine: SkeletonStateMachine = $SkeletonStateMachine

#this happens onece when load into the screen
func _ready() -> void:
	position = start_position
	anim.active = true

#executes every frame, for non physics processes
func _process(delta) -> void:
	pass

func _physics_process(delta):
	pass
