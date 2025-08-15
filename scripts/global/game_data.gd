extends Node

var coins: int = 0

signal coins_loaded
signal game_loaded

func save_game():
	var save_data = {
		"coins": coins
		# Later: add more data here like "pokemons": [], "player_pos": Vector2()
	}
	# C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	print("Save game success")

func load_game():
	# C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())

		if typeof(data) == TYPE_DICTIONARY:
			coins = data.get("coins", 0)
			emit_signal("coins_loaded")
			emit_signal("game_loaded")
			print("Load game success")
		else:
			print("Load game failed: invalid format")
	else:
		print("No save file found")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
