extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var run_speed: int = 110

var interactButton: Control = null

func _on_physics_process(_delta: float) -> void:
	if player.is_water_in_front():
		interactButton.visible = true
	else:
		interactButton.visible = false
		
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
	if GameInputEvents.is_interact_input() and player.is_water_in_front():
		# Move player slightly forward into water
		player.collision_mask &= ~((1 << 1) | (1 << 6))
		player.global_position += player.player_direction * 20
		transition.emit("Surf")
		return
		
	if GameInputEvents.is_cycle_toggle():
		transition.emit("CycleIdle")
	elif !GameInputEvents.is_movement_input():
		transition.emit("Idle")
	elif !GameInputEvents.is_space_pressed():
		transition.emit("Walk")

func _on_enter() -> void:
	interactButton = player.get_node("FButton")

func _on_exit() -> void:
	animated_sprite_2d.stop()
