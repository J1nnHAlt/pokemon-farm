extends Node2D

@export var wild_arbok_scene = preload("res://scenes/wild_pokemon/wild_arbok/wild_arbok.tscn")
var max_attempts: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if GameData.wild_arbok_amt < 2:
		spawn_near_player()
	

func spawn_near_player():
	
	for i in range(max_attempts):
		print("Timeout attempt")
		# pick random position on screen
		var pos = get_random_position_in_camera(get_viewport().get_camera_2d())	
		print("Attempting spawn at: ", pos, " Camera at: ", get_viewport().get_camera_2d().global_position)
		if is_valid_spawn(pos):
			print("Valid spawn found at: ", pos)
			# found valid free spot
			var wild_arbok = wild_arbok_scene.instantiate()
			wild_arbok.global_position = pos
			get_parent().get_node("WildArboksHandler").add_child(wild_arbok)
			GameData.wild_arbok_amt += 1
			return
	
	print("⚠ Could not find valid spawn position after", max_attempts, "tries")


func is_valid_spawn(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.collision_mask = 0xFFFFFFFF
	
	var result = space_state.intersect_point(params)
	return result.is_empty()   # true if nothing blocks this position


func get_random_position_in_camera(camera: Camera2D) -> Vector2:
	var viewport_rect = get_viewport().get_visible_rect()
	# The visible world size is viewport size divided by zoom
	var world_size = viewport_rect.size / camera.zoom
	var half_size = world_size / 2
	var cam_center = camera.global_position
	
	# random offset within screen bounds
	var offset = Vector2(
		randf_range(-half_size.x, half_size.x),
		randf_range(-half_size.y, half_size.y)
	)
	
	return cam_center + offset
