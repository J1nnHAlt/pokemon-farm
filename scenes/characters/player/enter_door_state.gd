class_name EnterDoorState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var target_door: Door
var move_speed: float = 50.0
var move_distance: float = 16.0
var traveled: float = 0.0
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
		
		teleport_to_door_target(target_door)
		player.visible = true
		transition.emit("Walk")


func _on_exit() -> void:
	# Re-enable collisions
	player.set_collision_mask_value(8, true)
	player.set_collision_mask_value(9, true)
	player.velocity = Vector2.ZERO
	player.visible = true  

func teleport_to_door_target(door: Door) -> void:
	var tree = get_tree()
	var old_scene = tree.current_scene
	var interior_scene = load(door.target_scene).instantiate()

	# 1. Detach player before freeing old scene
	old_scene.remove_child(player)

	# 2. Add new scene
	tree.root.add_child(interior_scene)
	tree.current_scene = interior_scene

	# 3. Free old scene AFTER new scene is set
	old_scene.queue_free()

	# 4. Add player into the new scene
	interior_scene.add_child(player)

	# 5. Teleport player to spawn point
	var spawn_point = interior_scene.get_node_or_null(door.target_spawn_name)
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		push_warning("Spawn point not found: %s" % door.target_spawn_name)
