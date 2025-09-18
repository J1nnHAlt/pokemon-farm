class_name WalkState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 100

static var cooldown_used_once = true
static var can_walk = true
static var walk_timer = 0.0
const WALK_COOLDOWN_TIME = 0.1  # Adjust as needed

var interact_active: bool = false   # track current interaction state

var interactButton: Control = null

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	# Only update interaction source if state actually changes
	var should_interact = player.is_water_in_front()
	if should_interact != interact_active:
		interact_active = should_interact
		if interact_active:
			player.set_interaction_source(self, true)
		else:
			player.set_interaction_source(self, false)
	
	if not WalkState.can_walk:
		WalkState.walk_timer += _delta
		if WalkState.walk_timer >= WALK_COOLDOWN_TIME:
			WalkState.can_walk = true
		player.velocity = Vector2.ZERO
		player.move_and_slide()
		return
	
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * speed
	player.move_and_slide()


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
		
	if GameInputEvents.is_cycle_toggle():
		player.velocity = Vector2.ZERO
		transition.emit("CycleIdle")
		return

	if not WalkState.can_walk:
		# While waiting for cooldown, block other transitions
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
	
	if GameInputEvents.is_fishing_input() and player.is_water_in_front():
		transition.emit("Fishing")
		return
		
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")
	elif GameInputEvents.is_space_pressed():
		transition.emit("Run")



func _on_enter() -> void:
	player.set_collision_mask_value(2, true)
	
	interactButton = player.get_node("FButton")
	CycleIdleState.cooldown_used_once = false
	CycleIdleState.can_cycle = false
	CycleIdleState.cycle_timer = 0.0
	
	if not WalkState.cooldown_used_once:
		WalkState.can_walk = false
		WalkState.walk_timer = 0.0
		WalkState.cooldown_used_once = true
	else:
		WalkState.can_walk = true  # Already used once, skip cooldown

func _on_exit() -> void:
	animated_sprite_2d.stop()
