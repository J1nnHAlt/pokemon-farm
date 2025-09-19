extends Control
signal dialog_done
signal yes_selected
signal no_selected

@onready var label: Label = $Label
@onready var arrow = $Arrow
@onready var enter_button = $Enter_button
@onready var sfx_enter: AudioStreamPlayer2D = $sfx_enter
@onready var yes_no_menu: NinePatchRect = $YesNoMenu
@onready var yes_label: Label = $YesNoMenu/VBoxContainer/YES
@onready var no_label: Label = $YesNoMenu/VBoxContainer/NO

var text_speed := 0.03
var pages: Array[String] = []
var current_page := 0
var char_index := 0
var is_typing := false

# Session token to cancel in-progress typing
var typing_session_id: int = 0

# Yes/No menu state
var yes_no_index := 0  # 0 = YES, 1 = NO

func _ready() -> void:
	yes_no_menu.visible = false

# Normal dialog flow ---------------------------
func start_dialog(pages_in: Array[String]) -> void:
	pages = pages_in
	current_page = 0
	show()
	_show_page()

func _show_page() -> void:
	if current_page >= pages.size():
		return

	typing_session_id += 1
	var session := typing_session_id

	label.text = ""
	char_index = 0
	is_typing = true
	arrow.visible = false
	enter_button.visible = false

	_type_next_char(session)

func _type_next_char(session: int) -> void:
	if session != typing_session_id:
		return

	if char_index < pages[current_page].length():
		label.text += pages[current_page][char_index]
		char_index += 1
		await get_tree().create_timer(text_speed).timeout
		_type_next_char(session)
	else:
		if session != typing_session_id:
			return
		is_typing = false
		arrow.visible = true
		enter_button.visible = true
		if arrow and arrow.has_method("play"):
			arrow.play("default")
		if enter_button and enter_button.has_method("play"):
			enter_button.play("default")

# YES/NO Menu -----------------------------------
func show_yes_no() -> void:
	yes_no_menu.visible = true
	yes_no_index = 0
	_update_yes_no_selection()

func _update_yes_no_selection() -> void:
	if yes_no_index == 0:
		yes_label.add_theme_color_override("font_color", Color.YELLOW)
		no_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		yes_label.add_theme_color_override("font_color", Color.WHITE)
		no_label.add_theme_color_override("font_color", Color.YELLOW)
		
# Input handling -------------------------------
func _unhandled_input(event: InputEvent) -> void:
	# Handle Yes/No menu first
	if yes_no_menu.visible:
		if event.is_action_pressed("ui_up"):
			yes_no_index = max(0, yes_no_index - 1)
			_update_yes_no_selection()
		elif event.is_action_pressed("ui_down"):
			yes_no_index = min(1, yes_no_index + 1)
			_update_yes_no_selection()
		elif event.is_action_pressed("enter"):
			if sfx_enter: sfx_enter.play()
			yes_no_menu.visible = false
			if yes_no_index == 0:
				emit_signal("yes_selected")
			else:
				emit_signal("no_selected")
		return

	# Normal dialog input
	if not visible:
		return

	if event.is_action_pressed("enter"):
		if is_typing:
			if sfx_enter: sfx_enter.play()
			typing_session_id += 1
			label.text = pages[current_page]
			char_index = pages[current_page].length()
			is_typing = false
			arrow.visible = true
			enter_button.visible = true
			if arrow and arrow.has_method("play"):
				arrow.play("default")
			if enter_button and enter_button.has_method("play"):
				enter_button.play("default")
		else:
			current_page += 1
			if current_page < pages.size():
				_show_page()
			else:
				hide()
				arrow.visible = false
				enter_button.visible = false
				emit_signal("dialog_done")
