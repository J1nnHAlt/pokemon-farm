extends Control

@onready var volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/volume
var default_volume: float = 5.0  # 0–10
var opened_from: String = ""
var pause_menu_ref: Node = null

func _ready() -> void:
	volume_slider.value = default_volume
	_on_volume_value_changed(default_volume)
	$AnimationPlayer.play("blur")


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,960))


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/10))


func _on_back_button_pressed() -> void:
	print("back pressed")
	if opened_from == "main_menu":
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

	elif opened_from == "pause_menu" and pause_menu_ref:
		pause_menu_ref.get_node("AnimationPlayer").play("blur")
		queue_free()  # Close the settings menu
