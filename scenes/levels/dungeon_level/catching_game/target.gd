extends Area2D

signal target_entered
signal target_exited

const SPEED := 300
var on_arbok := false

func _physics_process(delta: float) -> void:
	_check_on_arbok()
	
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	global_position += direction * SPEED * delta

func _check_on_arbok():
	var bodies := get_overlapping_bodies()
	if bodies.is_empty() and on_arbok:
		on_arbok = false
		target_exited.emit()
	elif not bodies.is_empty() and not on_arbok:
		on_arbok = true
		target_entered.emit()
