extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var interact_active: bool = false   # track current interaction state

var interactButton: Control = null

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	else:
		animated_sprite_2d.play("idle_front")
	
	# Only update interaction source if state actually changes
	var should_interact = player.is_water_in_front()
	if should_interact != interact_active:
		interact_active = should_interact
		if interact_active:
			player.set_interaction_source(self, true)
		else:
			player.set_interaction_source(self, false)

func _on_next_transitions() -> void:
	var direction = GameInputEvents.movement_input()
	
	# Update the raycast based on facing direction
	if direction != Vector2.ZERO:
		player.player_direction = direction
		player.update_interaction_ray()
	
	# Check if player is in front of a door
	var door = player.get_door_in_front()
	# if player is in front of a door, when move up will enter to the building
	if door and direction == Vector2.UP:
		print("@Door: EnterDoor triggered")
		transition.emit("EnterDoor")
		return
	
	if GameInputEvents.is_interact_input() and player.is_water_in_front():
		# Move player slightly forward into water
		player.collision_mask &= ~((1 << 1) | (1 << 6))
		player.global_position += player.player_direction * 20
		transition.emit("Surf")
		return
	
	if GameInputEvents.is_fishing_input() and player.is_water_in_front():
		transition.emit("Fishing")
		return
	
	if GameInputEvents.is_cycle_toggle():
		transition.emit("CycleIdle")
	elif GameInputEvents.is_movement_input():
		transition.emit("Walk")
	elif player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.is_watering_input():
		transition.emit("Watering")


func _on_enter() -> void:
	player.set_collision_mask_value(2, true)
	interactButton = player.get_node("FButton")


func _on_exit() -> void:
	animated_sprite_2d.stop()
