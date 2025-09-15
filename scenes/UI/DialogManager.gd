extends Control
signal dialog_done

@onready var label: Label = $Label
@onready var arrow = $Arrow
@onready var enter_button = $Enter_button

var text_speed := 0.03
var pages: Array[String] = []
var current_page := 0
var char_index := 0
var is_typing := false

# Session token to cancel in-progress typing
var typing_session_id: int = 0

func start_dialog(pages_in: Array[String]) -> void:
	pages = pages_in
	current_page = 0
	show()
	_show_page()

func _show_page() -> void:
	if current_page >= pages.size():
		return

	# cancel any previous typing
	typing_session_id += 1
	var session := typing_session_id

	label.text = ""
	char_index = 0
	is_typing = true
	arrow.visible = false
	enter_button.visible = false

	# start typing for this session
	_type_next_char(session)

func _type_next_char(session: int) -> void:
	# cancelled? stop
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

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("enter"):
		if is_typing:
			# cancel current typing and instantly show full page
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
			# go to next page or end
			current_page += 1
			if current_page < pages.size():
				_show_page()
			else:
				hide()
				arrow.visible = false
				enter_button.visible = false
				emit_signal("dialog_done")
