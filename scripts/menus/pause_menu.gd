extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		print("ESC pressed")
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		print("ESC pressed")
		resume()



func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")
	var settings_menu = preload("res://scenes/menus/settings_menu.tscn").instantiate()
	settings_menu.opened_from = "pause_menu"
	settings_menu.pause_menu_ref = self  # Pass reference to pause menu
	add_child(settings_menu)
	$AnimationPlayer.play_backwards("blur")  # Hide pause menu while settings is open

func _on_quit_pressed() -> void:
	get_tree().quit()
