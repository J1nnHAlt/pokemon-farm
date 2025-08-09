extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Coin.load_game()
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test_scene_tilemap.tscn")


func _on_options_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")
	var settings_menu = preload("res://scenes/menus/settings_menu.tscn").instantiate()
	settings_menu.opened_from = "main_menu"
	add_child(settings_menu)


func _on_exit_button_pressed() -> void:
	Coin.save_game()
	get_tree().quit()
