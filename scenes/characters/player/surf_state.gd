class_name SurfState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 150

var interactButton: Control = null

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	if !player.is_water_in_front():
		interactButton.visible = true
	else:
		interactButton.visible = false

	if direction != Vector2.ZERO:
		# Save direction & update facing
		player.player_direction = direction
		player.velocity = direction * speed
	else:
		# No input → stay idle in surf
		player.velocity = Vector2.ZERO

	# Pick animation based on facing direction
	var anim_name = ""
	if player.player_direction == Vector2.UP:
		anim_name = "surf_back"
	elif player.player_direction == Vector2.RIGHT:
		anim_name = "surf_right"
	elif player.player_direction == Vector2.DOWN:
		anim_name = "surf_front"
	elif player.player_direction == Vector2.LEFT:
		anim_name = "surf_left"

	if anim_name != "":
		animated_sprite_2d.play(anim_name)

	player.move_and_slide()


func _on_next_transitions() -> void:
	# Leave water when pressing F and no water in front
	if GameInputEvents.is_interact_input() and !player.is_water_in_front():
		player.global_position += player.player_direction * 20
		transition.emit("Walk")
		return

func _on_enter() -> void:
	player.set_collision_mask_value(7, true)
	
	interactButton = player.get_node("FButton")
	interactButton.visible = false
	
	var surf_music = player.get_node("SurfMusic") as AudioStreamPlayer
	if surf_music and not surf_music.playing:
		surf_music.play()
	pass

func _on_exit() -> void:
	player.set_collision_mask_value(2, true)
	var surf_music = player.get_node("SurfMusic") as AudioStreamPlayer
	if surf_music and surf_music.playing:
		surf_music.stop()
	animated_sprite_2d.stop()
