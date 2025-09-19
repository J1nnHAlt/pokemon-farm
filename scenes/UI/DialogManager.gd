extends Control
signal dialog_done
signal yes_selected
signal no_selected
signal choice_active(is_active: bool)

@onready var label: Label = $Label
@onready var arrow = $Arrow
@onready var enter_button = $Enter_button
@onready var sfx_enter: AudioStreamPlayer2D = $sfx_enter
@onready var sfx_upgrade: AudioStreamPlayer2D = $sfx_upgrade
@onready var yes_no_menu: NinePatchRect = $YesNoMenu
@onready var yes_label: Label = $YesNoMenu/VBoxContainer/YES
@onready var no_label: Label = $YesNoMenu/VBoxContainer/NO

var text_speed := 0.03
var pages: Array = []            # untyped array to avoid strict arg errors
var current_page := 0
var char_index := 0
var is_typing := false

# Session token to cancel in-progress typing coroutines
var typing_session_id: int = 0

# Yes/No menu state
var yes_no_index := 0  # 0 = YES, 1 = NO

func _ready() -> void:
	yes_no_menu.visible = false
	# make sure labels exist (avoid crash if renamed)
	if not yes_label:
		push_warning("Yes label node not found at path: %s" % "$YesNoMenu/VBoxContainer/YES")
	if not no_label:
		push_warning("No label node not found at path: %s" % "$YesNoMenu/VBoxContainer/NO")

# ------------------------------------------------
# Dialog flow
# pages_in is untyped Array to keep caller simple
func start_dialog(pages_in: Array) -> void:
	if not pages_in:
		return
	# ensure we have a real array copy
	pages = pages_in.duplicate()
	current_page = 0
	show()
	emit_signal("choice_active", true)  # disable player movement
	_show_page()

func _show_page() -> void:
	if current_page >= pages.size():
		return

	# cancel any previous typing session
	typing_session_id += 1
	var session := typing_session_id

	label.text = ""
	char_index = 0
	is_typing = true
	arrow.visible = false
	enter_button.visible = false

	_type_next_char(session)

func _type_next_char(session: int) -> void:
	# cancelled? stop
	if session != typing_session_id:
		return

	# guard page index
	if current_page >= pages.size():
		return

	var page_text: String = str(pages[current_page])

	if char_index < page_text.length():
		label.text += page_text[char_index]
		char_index += 1
		await get_tree().create_timer(text_speed).timeout
		_type_next_char(session)
	else:
		# still valid session?
		if session != typing_session_id:
			return
		is_typing = false
		arrow.visible = true
		enter_button.visible = true
		if arrow and arrow.has_method("play"):
			arrow.play("default")
		if enter_button and enter_button.has_method("play"):
			enter_button.play("default")

# ------------------------------------------------
# Yes/No menu control (used by NPCs)
func show_yes_no() -> void:
	# show choice box above dialog, reset selection
	yes_no_menu.visible = true
	yes_no_index = 0
	print("@Dialog: show_yes_no called")
	_update_yes_no_selection()
	emit_signal("choice_active", true)  # disable player movement

func hide_yes_no() -> void:
	yes_no_menu.visible = false
	yes_no_index = 0
	print("@Dialog: hide_yes_no called")
	_update_yes_no_selection()

# safe dialog hide that cancels typing
func hide_dialog() -> void:
	# cancel typing coroutines and hide everything
	typing_session_id += 1
	is_typing = false
	hide()
	arrow.visible = false
	enter_button.visible = false
	hide_yes_no()
	
	print("@Dialog: hide_dialog called")

func _update_yes_no_selection() -> void:
	# color the selected label (use theme override so it respects fonts)
	if yes_no_index == 0:
		yes_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0)) # yellow
		no_label.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0))  # white
		print("@Dialog: yes selected from update_yes_no_selection")
	else:
		yes_label.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0))
		no_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0))
		print("@Dialog: no selected from update_yes_no_selection")

# ------------------------------------------------
# Input handling
func _unhandled_input(event: InputEvent) -> void:
	# YES/NO has higher priority
	if yes_no_menu.visible:
		if event.is_action_pressed("ui_up"):
			yes_no_index = max(0, yes_no_index - 1)
			_update_yes_no_selection()
		elif event.is_action_pressed("ui_down"):
			yes_no_index = min(1, yes_no_index + 1)
			_update_yes_no_selection()
		elif event.is_action_pressed("enter"):
			if sfx_enter:
				sfx_enter.play()
			yes_no_menu.visible = false
			if yes_no_index == 0:
				if sfx_upgrade:
					sfx_upgrade.play()
				emit_signal("yes_selected")
			else:
				emit_signal("no_selected")
		return

	# Normal dialog input
	if not visible:
		return

	if event.is_action_pressed("enter"):
		if is_typing:
			# skip typing (no choice sound here)
			typing_session_id += 1
			label.text = str(pages[current_page]) if current_page < pages.size() else ""
			char_index = label.text.length()
			is_typing = false
			arrow.visible = true
			enter_button.visible = true
			if arrow and arrow.has_method("play"):
				arrow.play("default")
			if enter_button and enter_button.has_method("play"):
				enter_button.play("default")
		else:
			# play confirm sound, advance or finish
			if sfx_enter:
				sfx_enter.play()
			current_page += 1
			if current_page < pages.size():
				_show_page()
			else:
				print("@Dialog: hide() called from unhandled_input")
				hide()
				arrow.visible = false
				enter_button.visible = false
				emit_signal("choice_active", false)  # enable player movement
				emit_signal("dialog_done")
