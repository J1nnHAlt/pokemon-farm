extends Node

signal dialog_started
signal dialog_finished

@onready var dialog_box = $DialogBox

# Store all dialog here or load from JSON
var dialog_data := {
	"npc_prof_oak": [
		"Hello there!\nWelcome to the world of monsters!\n\n" +
		"My name is Oak!\nPeople call me the monster PROF!"
	],
	"found_potion": [
		"You found a Potion!\n\nIt was placed in the Bag."
	]
}

var active_event: String = ""

func start_dialog(event_id: String):
	if event_id in dialog_data:
		active_event = event_id
		emit_signal("dialog_started", event_id)
		dialog_box.start_dialog(dialog_data[event_id][0])
		dialog_box.connect("dialog_done", Callable(self, "_on_dialog_done"), CONNECT_ONE_SHOT)

func _on_dialog_done():
	emit_signal("dialog_finished", active_event)
	active_event = ""
