extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var cycle_speed: int = 150

func _on_physics_process(_delta: float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()

	if direction == Vector2.UP:
		animated_sprite_2d.play("bicycle_move_back")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("bicycle_move_right")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("bicycle_move_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("bicycle_move_left")

	if direction != Vector2.ZERO:
		player.player_direction = direction

	player.velocity = direction * cycle_speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	if GameInputEvents.is_cycle_toggle():
		# Reset cooldown so walking requires pause
		WalkState.cooldown_used_once = false
		WalkState.can_walk = false
		WalkState.walk_timer = 0.0
		transition.emit("Idle")
	elif !GameInputEvents.is_movement_input():
		transition.emit("CycleIdle") # Stop moving on bike

func _on_exit() -> void:
	animated_sprite_2d.stop()
