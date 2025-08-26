class_name EnterDoorState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var target_door: Door
var move_speed: float = 50.0      # px/sec
var move_distance: float = 16.0   # total px to move
var traveled: float = 0.0         # how far moved so far
var moving: bool = false

func _on_enter() -> void:
	target_door = player.get_door_in_front()
	if not target_door:
		transition.emit("Idle")
		return

	player.set_collision_mask_value(8, false)
	player.set_collision_mask_value(9, false)

	# Align player's X
	player.global_position.x = target_door.global_position.x

	# Reset traveled distance
	traveled = 0.0
	moving = true
	animated_sprite_2d.play("walk_back")

func _physics_process(delta: float) -> void:
	if not moving:
		return

	if target_door.has_node("AnimatedSprite2D"):
		target_door.open_door()
	# Move by speed * delta each frame
	var step = move_speed * delta
	player.global_position.y -= step
	traveled += step

	# Stop once we've traveled enough
	if traveled >= move_distance:
		moving = false
		player.visible = false
		await get_tree().create_timer(0.3).timeout

		player.global_position = target_door.target_position
		player.visible = true
		transition.emit("Walk")


func _on_exit() -> void:
	# Re-enable collisions
	player.set_collision_mask_value(8, true)
	player.set_collision_mask_value(9, true)
	player.velocity = Vector2.ZERO
	player.visible = true  
