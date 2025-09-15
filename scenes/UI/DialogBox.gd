extends Control
signal dialog_done

@onready var label: Label = $Label
@onready var arrow: AnimatedSprite2D = $Arrow

var text_speed := 0.03
var pages: Array = []
var current_page := 0
var char_index := 0
var is_typing := false

func start_dialog(text: String):
	# Split by double newline (\n\n) → pages
	pages = text.split("\n\n")
	current_page = 0
	_show_page()

func _show_page():
	label.text = ""
	char_index = 0
	is_typing = true
	arrow.visible = false
	_type_next_char()

func _type_next_char():
	if char_index < pages[current_page].length():
		label.text += pages[current_page][char_index]
		char_index += 1
		await get_tree().create_timer(text_speed).timeout
		_type_next_char()
	else:
		is_typing = false
		arrow.visible = true  # show "press A" arrow
		if not arrow.is_playing():
			arrow.play("default")

func _unhandled_input(event):
	if event.is_action_pressed("enter"):
		if is_typing:
			# Skip typing → show full page instantly
			label.text = pages[current_page]
			is_typing = false
			arrow.visible = true
			if not arrow.is_playing():
				arrow.play("default")
		else:
			# Already done typing → next page or finish
			current_page += 1
			if current_page < pages.size():
				_show_page()
			else:
				hide()
				emit_signal("dialog_done")
