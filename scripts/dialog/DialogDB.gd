extends Node

# Simple dictionary to store dialogs
# Keys = NPC ID, Values = Array of pages (multi-page dialog)
var dialogs := {
	"villager_1": [
		"Hello there!\n\nIt’s a nice day, isn’t it?",
		"Be careful, I saw some wild monsters in the grass."
	],
	"professor_oak": [
		"Welcome to the world of Pokémon!",
		"My name is Oak, and people call me the Pokémon Professor."
	],
	"shopkeeper": [
		"Hello! Want to buy something?",
		"Come back anytime."
	]
}

func get_dialog(npc_id: String, index: int = 0) -> String:
	if dialogs.has(npc_id):
		var pages = dialogs[npc_id]
		if index >= 0 and index < pages.size():
			return pages[index]
	return ""
