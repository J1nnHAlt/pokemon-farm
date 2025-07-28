extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var run_speed: int = 110

func _on_physics_process(_delta: float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()

	if direction == Vector2.UP:
		animated_sprite_2d.play("run_back")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("run_right")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("run_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("run_left")

	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * run_speed
	player.move_and_slide()


func _on_next_transitions() -> void:
	if GameInputEvents.is_cycle_toggle():
		transition.emit("CycleIdle")
	elif !GameInputEvents.is_movement_input():
		transition.emit("Idle")
	elif !GameInputEvents.is_run_pressed():
		transition.emit("Walk")


func _on_exit() -> void:
	animated_sprite_2d.stop()
