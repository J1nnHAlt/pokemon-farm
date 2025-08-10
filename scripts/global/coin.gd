extends Node

@onready var coins: int = -1

signal coins_loaded

func add_coins(amount: int):
	coins += amount

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		return true
	return false

func save_game():
	var save_data = {"coins": coins}
#	save under this path
#	C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	print("save game success")

func load_game():
	if FileAccess.file_exists("user://savegame.json"):
		print("load game success")
		#load from this path
#		C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		coins = data["coins"]
		coins_loaded.emit()
	#print("load game failed")
