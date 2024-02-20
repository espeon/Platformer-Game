extends CharacterBody2D



enum states {IDLE, RUNNING, CROUCHING, ROLLING, JUMP, FALL, ATTACK}
var state_functions: Dictionary = {
	states.IDLE : idle_function,
	states.RUNNING : running_function, 
	states.CROUCHING : crouching_function,
	states.ROLLING : rolling_function,
	states.JUMP : jump_function, 
	states.FALL : fall_function,
	states.ATTACK : attack_function
}
var cur_state = states.IDLE


func _physics_process(delta):
	state_functions[cur_state].call()
	
	
	move_and_slide()


func idle_function():
	pass
	
func running_function():
	pass

func crouching_function():
	pass

func rolling_function():
	pass

func jump_function():
	pass

func fall_function():
	pass

func attack_function():
	pass
