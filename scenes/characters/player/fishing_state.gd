class_name FishingState
extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var spacebar: AnimatedSprite2D
@export var fishing_bar: TextureProgressBar
@export var fish_warning: TextureRect


var is_fishing: bool = false
var bar_value: int = 0
var decrease_timer: Timer

# BGM
var encounter_music: AudioStreamPlayer
var surf_music: AudioStreamPlayer
var capture_music: AudioStreamPlayer
var exclaim_sfx: AudioStreamPlayer

# remember which state we entered from
var entered_from: String = ""

func _on_enter() -> void:
	is_fishing = true
	encounter_music = player.get_node("EncounterMusic") as AudioStreamPlayer
	surf_music = player.get_node("SurfMusic") as AudioStreamPlayer
	capture_music = player.get_node("CaptureMusic") as AudioStreamPlayer
	exclaim_sfx = player.get_node("sfx_exclaim") as AudioStreamPlayer

	# Play fishing animation based on direction
	match player.player_direction:
		Vector2.UP:
			animated_sprite_2d.play("fishing_back")
		Vector2.DOWN:
			animated_sprite_2d.play("fishing_front")
		Vector2.LEFT:
			animated_sprite_2d.play("fishing_left")
		Vector2.RIGHT:
			animated_sprite_2d.play("fishing_right")

	# Hide bar + warning until fish bites
	fishing_bar.visible = false
	fish_warning.visible = false
	bar_value = 0
	fishing_bar.value = bar_value

	# Random bite time
	var bite_time = randi_range(2, 6)
	await get_tree().create_timer(bite_time).timeout

	if is_fishing:
		_on_fish_bite()

func _on_exit() -> void:
	is_fishing = false
	if decrease_timer:
		decrease_timer.stop()
	fishing_bar.visible = false
	animated_sprite_2d.stop()

func _on_fish_bite() -> void:
	fish_warning.visible = true
	exclaim_sfx.play()
	
	if encounter_music and not encounter_music.playing:
		surf_music.stop()
		encounter_music.play()
		
	await get_tree().create_timer(1.5).timeout
	fish_warning.visible = false
	
	
	fishing_bar.visible = true
	spacebar.visible = true
	bar_value = 50
	fishing_bar.value = bar_value
	
	
	print("@Fishing: Start Fishing")

	decrease_timer = Timer.new()
	decrease_timer.wait_time = 0.5
	decrease_timer.autostart = true
	decrease_timer.timeout.connect(_on_bar_decrease)
	add_child(decrease_timer)

func _on_bar_decrease() -> void:
	bar_value -= 5
	fishing_bar.value = bar_value
	if bar_value <= 0:
		print("@Fishing: Pokemon escaped!")
		if encounter_music.playing:
			encounter_music.stop()
		if entered_from == "surf" and surf_music:
			surf_music.play()
		transition.emit("_previous")  # return to Surf or Walk automatically

func _input(_event: InputEvent) -> void:
	if is_fishing and fishing_bar.visible and spacebar.visible:
		spacebar.play("press_spacebar")
		if GameInputEvents.is_space_pressed():
			bar_value += 3
			fishing_bar.value = bar_value
			if bar_value >= 100:
				spacebar.stop()
				spacebar.visible = false
				print("@Fishing: Caught the pokemon!")
				if encounter_music.playing:
					encounter_music.stop()
				if capture_music and not capture_music.playing:
					if surf_music: surf_music.stop()
					capture_music.play()
				
				# Determine which pokemon is caught by fishing rate
				var pokemon = _determine_catch()
				print("@Fishing: You caught a ", pokemon, "!")
				
				transition.emit("_previous")  # return to Surf or Walk automatically

# the fishing rate
func _determine_catch() -> String:
	var roll = randi() % 100
	
	if roll < 60:
		return "Magikarp"      # 0–59 → 60%
	elif roll < 85:
		return "Seaking"       # 60–84 → 25%
	elif roll < 95:
		return "Gyarados"      # 85–94 → 10%
	else:
		return "Kyogre"        # 95–99 → 5%
