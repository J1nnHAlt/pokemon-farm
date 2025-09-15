# DialogDB.gd
extends Node

var dialogs := {
	"villager_1": [
		"Hello traveler!",
		"Nice weather today, right?",
		"Be careful out there!"
	],
	"pikachu": [
		"I'm too busy to talk."
	]
}

func get_dialog(npc_id: String, index: int) -> String:
	if npc_id in dialogs and index < dialogs[npc_id].size():
		return dialogs[npc_id][index]
	return ""

func get_dialog_count(npc_id: String) -> int:
	if npc_id in dialogs:
		return dialogs[npc_id].size()
	return 0
