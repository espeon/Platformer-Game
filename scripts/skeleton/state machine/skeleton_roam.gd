extends SkeletonState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
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
