class_name CycleIdleState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

static var can_cycle := false
static var cooldown_used_once := false
static var cycle_timer := 0.0
const cycle_cooldown_time := 0.1 

var interactButton: Control = null

func _on_enter() -> void:
	interactButton = player.get_node("FButton")
	
	if not cooldown_used_once:
		can_cycle = false
		cycle_timer = 0.0
	else:
		can_cycle = true

	player.velocity = Vector2.ZERO
	
	var bicycle_music = player.get_node("BicycleMusic") as AudioStreamPlayer
	if bicycle_music and not bicycle_music.playing:
		bicycle_music.play()


func _on_physics_process(delta: float) -> void:
	if player.is_water_in_front():
		interactButton.visible = true
	else:
		interactButton.visible = false
	
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_bicycle_back")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_bicycle_right")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_bicycle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_bicycle_left")
	else:
		animated_sprite_2d.play("idle_bicycle_front")

	# Only count cooldown if it's not already used
	if not can_cycle and not cooldown_used_once:
		cycle_timer += delta
		if cycle_timer >= cycle_cooldown_time:
			can_cycle = true
			cooldown_used_once = true 

	player.move_and_slide()


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_interact_input() and player.is_water_in_front():
		# stop the music before enter surf state
		var bicycle_music = player.get_node("BicycleMusic") as AudioStreamPlayer
		if bicycle_music and bicycle_music.playing:
			bicycle_music.stop()
		# Move player slightly forward into water
		player.collision_mask &= ~((1 << 1) | (1 << 6))
		player.global_position += player.player_direction * 20
		transition.emit("Surf")
		return

	if GameInputEvents.is_cycle_toggle():
		print("[DEBUG] Toggle cycle -> Exit to Idle")

		var bicycle_music = player.get_node("BicycleMusic") as AudioStreamPlayer
		if bicycle_music and bicycle_music.playing:
			bicycle_music.stop()
		transition.emit("Idle")
	elif GameInputEvents.is_movement_input():
		if can_cycle:
			print("[DEBUG] Cooldown passed → Transitioning to Cycle")
			transition.emit("Cycle")
		else:
			print("[DEBUG] Waiting for cooldown before allowing Cycle")

func _on_exit() -> void:
	animated_sprite_2d.stop()
