extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var cycle_speed: int = 200

var bicycle_music: AudioStreamPlayer

var interact_active: bool = false   # track current interaction state

var interactButton: Control = null

func _on_physics_process(_delta: float) -> void:
	# Only update interaction source if state actually changes
	var should_interact = player.is_water_in_front()
	if should_interact != interact_active:
		interact_active = should_interact
		if interact_active:
			player.set_interaction_source(self, true)
		else:
			player.set_interaction_source(self, false)
	
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

	if player.can_move:
		player.velocity = direction * cycle_speed
		player.move_and_slide()

func _on_next_transitions() -> void:
	var direction = GameInputEvents.movement_input()
	
	if player.can_move:
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
	#		play the overlay summoning animation
			var overlay = get_tree().current_scene.get_node("CanvasLayer/SurfOverlay")
			overlay.play_overlay()
			
	#		wait the animation finish to perform transition logic
			var t = get_tree().create_timer(1.4)
			t.timeout.connect(func(): 
				# Move player slightly forward into water
				player.collision_mask &= ~((1 << 1) | (1 << 6))
				player.global_position += player.player_direction * 20
				transition.emit("Surf")
			)
			return
			
		if GameInputEvents.is_cycle_toggle():
			# Reset cooldown so walking requires pause
			WalkState.cooldown_used_once = false
			WalkState.can_walk = false
			WalkState.walk_timer = 0.0
			
			if bicycle_music and bicycle_music.playing:
				bicycle_music.stop()
			transition.emit("Idle")
		elif !GameInputEvents.is_movement_input():
			transition.emit("CycleIdle") # Stop moving on bike

func _on_enter() -> void:
	bicycle_music = player.get_node("BicycleMusic") as AudioStreamPlayer
	interactButton = player.get_node("FButton")

func _on_exit() -> void:
	animated_sprite_2d.stop()
