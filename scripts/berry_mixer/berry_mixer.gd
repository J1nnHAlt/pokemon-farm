extends Control

@onready var mix_button = $HBoxContainer/MixerPanel/MixButton
@onready var popup_scene = preload("res://scenes/BerryMixer/popup.tscn")  

@export var target_spawn: String = "MixerExitSpawn"
@export var main_scene = "res://scenes/test/test_scene_tilemap.tscn"
func _ready():
	mix_button.recipe_result.connect(show_craft_popup)
	$AudioStreamPlayer2D.stream.loop = true
	$AudioStreamPlayer2D.play()

func show_craft_popup(recipe_name: String):
	var message
	if recipe_name != "":
		message = "Successfully created!"
	else:
		message = "Berries wasted!"
	
	var popup = popup_scene.instantiate()
	add_child(popup)
	popup.set_display(recipe_name, message) 
	GameData.save_game()

func _on_exit_pressed() -> void:
	GameData.next_spawn = target_spawn
	get_tree().change_scene_to_file(main_scene)
