# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name SkeletonState
extends State

# Typed reference to the player node.
var player: Skeleton

func _ready() -> void:
	# The states are children of the `Skeleton` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `Skeleton` type.
	# If the `owner` is not a `Skeleton`, we'll get `null`.
	player = owner as Skeleton
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Skeleton.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass

# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
