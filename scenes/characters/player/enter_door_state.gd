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
	
	var door_enter_sfx = player.get_node("sfx_door_enter") as AudioStreamPlayer
	
	if target_door.has_node("AnimatedSprite2D"):
		if door_enter_sfx and !door_enter_sfx.playing:
			door_enter_sfx.play()
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

	old_scene.remove_child(player)
	tree.root.add_child(interior_scene)
	tree.current_scene = interior_scene
	old_scene.queue_free()

	interior_scene.add_child(player)

	# Spawn inside
	var spawn_point = interior_scene.get_node_or_null(door.target_spawn_name)
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		push_warning("Spawn point not found: %s" % door.target_spawn_name)

	# 👇 Connect exit handling
	for child in interior_scene.get_children():
		if child is EntrancePoint and child.linked_door_id == door.door_id:
			print("@Entrance: Connecting _on_exit_point_entered for door_id =", door.door_id)
			child.player_entered.connect(Callable(self, "_on_exit_point_entered").bind(door))


func _on_exit_point_entered(body: Node2D, door: Door) -> void:
	if body != player:
		print("@Entrance: Ignored, body is not player")
		return

	print("@Entrance: Player triggered exit for door_id =", door.door_id)

	var tree = get_tree()
	var old_scene = tree.current_scene
	print("@Entrance: Current scene =", old_scene.name)

	# Load outside world
	var outside_scene_path = "res://scenes/test/test_scene_tilemap.tscn"
	print("@Entrance: Loading outside scene from", outside_scene_path)
	var outside_scene = load(outside_scene_path).instantiate()

	# Move player out of old scene
	old_scene.remove_child(player)
	print("@Entrance: Removed player from old scene")

	# Switch scene
	tree.root.add_child(outside_scene)
	tree.current_scene = outside_scene
	print("@Entrance: Outside scene added, switched to", outside_scene.name)

	old_scene.queue_free()
	print("@Entrance: Freed old interior scene")

	# Add player into new scene
	outside_scene.add_child(player)
	print("@Entrance: Player added into outside scene")

	# Find door in the new outside scene that matches door_id
	var outside_door: Door = null
	for child in outside_scene.get_children():
		if child is Door:
			print("@Entrance: Found door candidate id =", child.door_id)
			if child.door_id == door.door_id:
				outside_door = child
				break

	if outside_door:
		player.global_position = outside_door.global_position + Vector2(0, 16)
		print("@Entrance: Player teleported outside to", player.global_position)
	else:
		push_warning("@Entrance: Could not find matching outside door with id: %s" % door.door_id)
