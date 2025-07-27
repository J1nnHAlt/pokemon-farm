extends Control

@onready var mix_button = $HBoxContainer/MixerPanel/MixButton
@onready var popup_scene = preload("res://scenes/BerryMixer/popup.tscn")  # your popup scene

func _ready():
	mix_button.recipe_result.connect(show_craft_popup)

func show_craft_popup(recipe_name: String):
	var message
	if recipe_name != "":
		message = "Successfully created!"
	else:
		message = "Berries wasted!"
	
	var popup = popup_scene.instantiate()
	add_child(popup)
	popup.set_display(recipe_name, message)  # create this method inside your popup script
