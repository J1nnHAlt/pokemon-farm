extends Control

@onready var day_night_panel: Control = $"../DayNightPanel"
@onready var sfx_open_menu: AudioStreamPlayer = $sfx_open_menu
@onready var sfx_close_menu: AudioStreamPlayer = $sfx_close_menu
@onready var sfx_click: AudioStreamPlayer = $sfx_click

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	day_night_panel.mouse_filter = Control.MOUSE_FILTER_STOP  # re-enable

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	day_night_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE  # disable

func testEsc():
	for action in ["esc", "throw_pokeball"]:
		if Input.is_action_just_pressed(action):
			print("Pressed:", action)
	
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		print("ESC pressed")
		sfx_open_menu.play()
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		print("ESC pressed")
		sfx_close_menu.play()
		sfx_close_menu.finished.connect(resume, CONNECT_ONE_SHOT)

func _on_resume_pressed() -> void:
	sfx_click.play()
	resume()

func _on_restart_pressed() -> void:
	sfx_click.play()
	resume()
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")
	sfx_click.play()
	var settings_menu = preload("res://scenes/menus/settings_menu.tscn").instantiate()
	settings_menu.opened_from = "pause_menu"
	settings_menu.pause_menu_ref = self  # Pass reference to pause menu
	add_child(settings_menu)
	$AnimationPlayer.play_backwards("blur")  # Hide pause menu while settings is open

func _on_quit_pressed() -> void:
	sfx_click.play()
	GameData.save_game()
	get_tree().quit()
