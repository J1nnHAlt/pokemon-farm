extends Node

var coins: int = 0
var inventory: Inv
var default_volume: float

var pet_arbok_amt: int = 0
var pet_victreebel_amt: int = 0
var pet_lapras_amt: int = 0

var next_spawn: String = ""


signal coins_loaded
signal volume_loaded
signal inventory_loaded
signal player_entered(pokemon: NonPlayableCharacter)
signal player_exited

var cheri_berry = load("res://scripts/inventory/items/berries/cheri_berry.tres")
var durin_berry = load("res://scripts/inventory/items/berries/durin_berry.tres")
var pamtre_berry = load("res://scripts/inventory/items/berries/pamtre_berry.tres")
var custa_berry = load("res://scripts/inventory/items/berries/custa_berry.tres")
var yache_berry = load("res://scripts/inventory/items/berries/yache_berry.tres")

func save_game():
	var save_data = {
		"coins": coins,
		"volume": default_volume,
		"pet_arbok_amt": pet_arbok_amt,
		"pet_victreebel_amt": pet_victreebel_amt,
		"pet_lapras_amt": pet_lapras_amt
		# Later: add more data here like "pokemons": [], "player_pos": Vector2()
	}
	# C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	if inventory:
		ResourceSaver.save(inventory, "user://inventory.tres")

	print("Save game success")

func load_game():
	# C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())

		if typeof(data) == TYPE_DICTIONARY:
			coins = data.get("coins", 0)
			default_volume = data.get("volume", 5.0)
			pet_arbok_amt = data.get("pet_arbok_amt", 0)
			pet_lapras_amt = data.get("pet_lapras_amt", 0)
			pet_victreebel_amt = data.get("pet_victreebel", 0)
			emit_signal("coins_loaded")
			emit_signal("volume_loaded")
			
			print("Load game success volume:", default_volume)
			
		else:
			print("Load game failed: invalid format")
	else:
		print("No save file found")
	
		# Load inventory
	if ResourceLoader.exists("user://inventory.tres"):
		var loaded_inv = ResourceLoader.load("user://inventory.tres")
		if loaded_inv is Inv:
			inventory = loaded_inv
			inventory_loaded.emit()
			print("Load inventory success")
	else:
		print("No inventory save found, creating new inventory")
		inventory = Inv.new()
		for i in range(12):
			var slot = InvSlot.new()
			slot.item = null
			inventory.slots.append(slot)
		for i in range(10):
			inventory.insert(cheri_berry)
			inventory.insert(durin_berry)
			inventory.insert(pamtre_berry)
			inventory.insert(custa_berry)
			inventory.insert(yache_berry)
		ResourceSaver.save(inventory, "user://inventory.tres")
		inventory_loaded.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	volume_loaded.connect(set_volume)
	pass

func set_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_volume/10))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
