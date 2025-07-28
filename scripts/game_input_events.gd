class_name GameInputEvents

static var direction: Vector2

static func movement_input() -> Vector2:
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN
	else:
		direction = Vector2.ZERO
		
	return direction

static func is_run_pressed() -> bool:
	return Input.is_action_pressed("run")

static func is_cycle_toggle() -> bool:
	return Input.is_action_just_pressed("cycle_toggle")

static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		print("[DEBUG] direction is ZERO in is_movement_input()")
		return false
	else:
		print("[DEBUG] direction is:", direction)
		return true
