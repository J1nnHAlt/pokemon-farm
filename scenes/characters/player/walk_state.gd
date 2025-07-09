extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 100

@export var tile_size: int = 32
var is_moving: bool = false
var target_position: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if is_moving:
		# Continue moving toward the target tile
		var direction = (target_position - player.position).normalized()
		var movement = direction * speed * _delta
		var remaining = player.position.distance_to(target_position)

		if movement.length() >= remaining:
			# Snap to final position and stop moving
			player.position = target_position
			is_moving = false
			player.velocity = Vector2.ZERO
		else:
			player.velocity = movement
			player.move_and_collide(movement)
		return

	# Handle new input only if not already moving
	var input_dir: Vector2 = GameInputEvents.movement_input().normalized()
	if input_dir == Vector2.ZERO:
		player.velocity = Vector2.ZERO
		return

	# Calculate the new target position (one tile ahead)
	var new_target = player.position + input_dir * tile_size

	# Check if that target is walkable
	if can_move_to(new_target):
		target_position = new_target
		is_moving = true
		player.player_direction = input_dir

		# Play walking animation based on direction
		if input_dir == Vector2.UP:
			animated_sprite_2d.play("walk_back")
		elif input_dir == Vector2.DOWN:
			animated_sprite_2d.play("walk_front")
		elif input_dir == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
		elif input_dir == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")


func _on_next_transitions() -> void:
	if !is_moving and !GameInputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	player.position = player.position.snapped(Vector2(tile_size, tile_size))
	is_moving = false
	#pass


func _on_exit() -> void:
	animated_sprite_2d.stop()

func can_move_to(pos: Vector2) -> bool:
	var test_motion = pos - player.position
	var collision = player.move_and_collide(test_motion, true)
	return collision == null
