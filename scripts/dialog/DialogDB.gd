# DialogDB.gd
extends Node

var dialogs := {
	"villager_1": [
		"Hello traveler!",
		"Nice weather today, right?",
		"Be careful out there!"
	],
	"villager_2": [
		"Good day to you!",
		"Have you seen the blacksmith today?",
		"Stay safe on your journey!"
	],
	"villager_3": [
		"Welcome to our village!",
		"The market is full of fresh goods.",
		"I heard there are strange noises in the forest."
	],
	"villager_4": [
		"Hey there! Fancy meeting you here.",
		"Watch your step, the road is slippery.",
		"Don't forget to greet the elder when you pass by."
	],
	"villager_5": [
		"Greetings, stranger!",
		"I love the sunrise here every morning.",
		"Many travelers have passed through recently."
	],
	"pikachu": [
		"I'm too busy to talk.",
		"Nigga, Nigga",
		"Reli Nigga?"
	],
	"professor_oak": [
		"Hello there! Ready for your journey?",
		"Choose your first Pokémon wisely.",
		"Remember to care for your Pokémon.",
		"The Pokédex will help you learn about them.",
		"Come back and tell me what you discover!"
	],
	"legendary_npc": [
		"Legendary pokemon can be summon using berries.",
		"Try to sell 10 berries from your inventory.",
		"It can buff your crops growth rate",
		"Remember it will only stays for 15 days"
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
