extends Control

@onready var catching_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/CatchingBar
@onready var timer: Timer = $Timer

var on_catch = false
var catch_speed := 1.5
var catching_value := 0.0
var caught = false
var game_has_ended = false

var target_pokemon
var target_pokeball

func _ready() -> void:
	print("target_pokemon:", target_pokemon)
	print("target_pokemon:", target_pokeball)
	timer.start()

func _physics_process(delta: float) -> void:
	print("Timer: ", timer.time_left)
	if on_catch: catching_value += catch_speed
	else: catching_value -= catch_speed
	
	if catching_value < 0: catching_value = 0
	elif catching_value >= 100: 
		caught = true
		_game_end()
	
	catching_bar.value = catching_value


func _on_target_target_entered() -> void:
	on_catch = true


func _on_target_target_exited() -> void:
	on_catch = false

func _game_end():
	if game_has_ended: # because of physics_process, got called many times
		return
	game_has_ended = true
	print("Pokeball ref:", target_pokeball)
	print("Pokeball in tree?:", target_pokeball.is_inside_tree())
#	check if caught or not
	if caught:
		play_captured_sfx()
		target_pokeball.queue_free()
		target_pokemon.queue_free()
		GameData.pet_arbok_amt += 1
		
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "global_position", global_position + Vector2(0,700), 0.5)
		await tween.finished
		get_tree().paused = false
		queue_free()
	else:
#		pokemon dodged it
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(self, "global_position", global_position + Vector2(0,700), 0.5)
		await tween.finished
		get_tree().paused = false
		queue_free()
		target_pokeball.queue_free()
		target_pokemon.queue_free()
		get_tree().current_scene.get_node("dodge_particle").global_position = target_pokemon.global_position
		get_tree().current_scene.get_node("dodge_particle").restart()
		
	


func _on_timer_timeout() -> void:
	_game_end()

func play_captured_sfx():
	var sound = AudioStreamPlayer.new()
	sound.stream = preload("res://pokemon-assets/Audio/ME/Voltorb Flip win.ogg")
	sound.autoplay = true
	get_tree().current_scene.add_child(sound)  # attach to scene, not this node
	sound.connect("finished", sound.queue_free)
