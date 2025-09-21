extends Node

var fishing_rod_level: int = 0
var coins: int = 0
var inventory: Inv
var default_volume: float

var pet_arbok_amt: int = 2
var pet_victreebel_amt: int = 0
var pet_lapras_amt: int = 0
var pet_lugia_amt: int = 0
var pet_magikarp_amt: int = 0
var pet_seaking_amt: int = 0
var pet_gyarados_amt: int = 0
var pet_kyogre_amt: int = 0

var wild_arbok_amt: int = 0 # used in dungeon for limit number of arboks
var saved_time: float = 0.0
var next_spawn: String = ""
var planted_crops: Array = [] # each entry: {pos = Vector2i, seed_name = String, growth_stage = int}
var is_scene_transitioning = false

signal coins_loaded
signal volume_loaded
signal inventory_loaded
signal player_entered(pokemon: NonPlayableCharacter)
signal player_exited

var berries = [
	preload("res://scripts/inventory/items/berries/cheri_berry.tres"), 
	preload("res://scripts/inventory/items/berries/durin_berry.tres"), 
	preload("res://scripts/inventory/items/berries/pamtre_berry.tres"), 
	#preload("res://scripts/inventory/items/berries/custa_berry.tres"), 
	#preload("res://scripts/inventory/items/berries/yache_berry.tres"), 
	#preload("res://scripts/inventory/items/berries/rawst_berry.tres")
]

var food = [
	preload("res://scripts/inventory/items/food/aqua_essence.tres"), 
	preload("res://scripts/inventory/items/food/dark_candy.tres"), 
	preload("res://scripts/inventory/items/food/leaf_bites.tres"), 
	preload("res://scripts/inventory/items/food/spicy_jam.tres"), 
	preload("res://scripts/inventory/items/food/sweet_juice.tres")
]

var seeds = [
	preload("res://scripts/inventory/items/seeds/cheri_seed.tres"),
	preload("res://scripts/inventory/items/seeds/custa_seed.tres"),
	preload("res://scripts/inventory/items/seeds/durin_seed.tres"),
	preload("res://scripts/inventory/items/seeds/pamtre_seed.tres"),
	preload("res://scripts/inventory/items/seeds/rawst_seed.tres"),
	preload("res://scripts/inventory/items/seeds/yache_seed.tres")
]

var pokeballs = [
	preload("res://scripts/inventory/items/pokeballs/pokeball.tres")
]

var seed_registry: Dictionary = {
	"CheriSeed": preload("res://scenes/crops/berry.tscn"),
	"CustaSeed": preload("res://scenes/crops/custa_berry.tscn"),
	"DurinSeed": preload("res://scenes/crops/durin_berry.tscn"),
	"PamtreSeed": preload("res://scenes/crops/pamtre_berry.tscn"),
	"RawstSeed": preload("res://scenes/crops/rawst_berry.tscn"),
	"YacheSeed": preload("res://scenes/crops/yache_berry.tscn"),
	# Add more seed → crop scene mappings here
}


func save_game():
	var total_minutes: int = int(DayAndNightCycleManager.time)
	var day: int = total_minutes / DayAndNightCycleManager.MINUTES_PER_DAY
	var minutes_today: int = total_minutes % DayAndNightCycleManager.MINUTES_PER_DAY
	var save_data = {
		"coins": coins,
		"volume": default_volume,
		"pet_arbok_amt": pet_arbok_amt,
		"pet_victreebel_amt": pet_victreebel_amt,
		"pet_lapras_amt": pet_lapras_amt,
		"pet_lugia_amt" : pet_lugia_amt,
		"pet_magikarp_amt": pet_magikarp_amt,
		"pet_seaking_amt": pet_seaking_amt,
		"pet_gyarados_amt": pet_gyarados_amt,
		"pet_kyogre_amt": pet_kyogre_amt,
		"time": DayAndNightCycleManager.time,
		"current_day": day,
		"current_time": minutes_today,

		# Later: add more data here like "pokemons": [], "player_pos": Vector2()
	}
	# C:\Users\<YourUsername>\AppData\Roaming\Godot\app_userdata\<YourGameName>\savegame.json
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	if inventory:
		ResourceSaver.save(inventory, "user://inventory.tres")

	print("Save game success")
	print("Saved time:", DayAndNightCycleManager.time)

func save_time():
	saved_time = DayAndNightCycleManager.time

func load_time():
	DayAndNightCycleManager.time = saved_time

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
			pet_magikarp_amt = data.get("pet_magikarp_amt", 0)
			pet_seaking_amt = data.get("pet_seaking_amt", 0)
			pet_gyarados_amt = data.get("pet_gyarados_amt", 0)
			pet_kyogre_amt = data.get("pet_kyogre_amt", 0)
			pet_lugia_amt = data.get("pet_lugia", 0)
			#planted_crops = data.get("planted_crops", [])
			#if data.has("time"):
				#DayAndNightCycleManager.time = float(data["time"])
				#DayAndNightCycleManager.recalculate_time()
				#print("Loaded RAW float time:", DayAndNightCycleManager.time)
			#else:
				#var loaded_day = int(data.get("current_day", 0))
				#var loaded_minutes_today = int(data.get("current_time", 0))
				#DayAndNightCycleManager.init_time(loaded_minutes_today, loaded_day)
				#print("Loaded by reconstruction: day", loaded_day, "minToday", loaded_minutes_today, "→ time:", DayAndNightCycleManager.time)


			#DayAndNightCycleManager.recalculate_time()

			emit_signal("coins_loaded")
			emit_signal("volume_loaded")
			
			print("Load game success volume:", default_volume)
			print("Loaded time:", DayAndNightCycleManager.time)
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
		for i in range(20):
			var slot = InvSlot.new()
			slot.item = null
			inventory.slots.append(slot)
		for berry in berries:
			for i in range(100):
				inventory.insert(berry)
		
		for f in food:
			for i in range(50):
				inventory.insert(f)
				
		for seed in seeds:
			for i in range(10):
				inventory.insert(seed)		
		
		for pokeball in pokeballs:
			for i in range(50):
				inventory.insert(pokeball)

		ResourceSaver.save(inventory, "user://inventory.tres")
		inventory_loaded.emit()
		DayAndNightCycleManager.recalculate_time()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	volume_loaded.connect(set_volume)
	pass
	
func save_crop(pos: Vector2i, seed_name: String):
	var pos_x = int(pos.x)
	var pos_y = int(pos.y)

	# Skip if crop already exists at this position
	for c in planted_crops:
		var cpos = c.get("pos", [0,0])
		if int(cpos[0]) == pos_x and int(cpos[1]) == pos_y:
			return

	planted_crops.append({
		"pos": [pos_x, pos_y],
		"seed_name": seed_name
	})

	save_game()

func get_crops_parent(scene_root: Node) -> Node:
	var crops_parent = scene_root.get_node_or_null("Crops")
	if crops_parent == null:
		crops_parent = Node2D.new()
		crops_parent.name = "Crops"
		scene_root.add_child(crops_parent)
	return crops_parent

func get_seed_scene(seed_name: String) -> PackedScene:
	print("Looking up seed: '" + seed_name + "' in registry keys: ", seed_registry.keys())
	if seed_registry.has(seed_name):
		return seed_registry[seed_name]
	return 

func remove_crop(pos: Vector2i):
	var pos_x = int(pos.x)
	var pos_y = int(pos.y)

	planted_crops = planted_crops.filter(func(c):
		var cpos = c.get("pos", [0,0])
		return int(cpos[0]) != pos_x or int(cpos[1]) != pos_y
	)

	save_game()


func set_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(default_volume/10))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
