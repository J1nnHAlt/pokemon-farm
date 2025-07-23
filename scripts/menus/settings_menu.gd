extends Control

@onready var volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/volume
var default_volume: float = 5.0  # 0–10

func _ready() -> void:
	volume_slider.value = default_volume
	_on_volume_value_changed(default_volume)


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
