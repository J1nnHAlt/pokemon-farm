extends Node2D
@onready var sfx_enter_scene: AudioStreamPlayer = $sfx_enter_scene

signal breed_reset

func get_crops_parent() -> Node:
	var crops_parent = get_node_or_null("Crops")
	if crops_parent == null:
		crops_parent = Node2D.new()
		crops_parent.name = "Crops"
		add_child(crops_parent) # attach to main scene root
	return crops_parent

#func load_crops():
	#print("Planted crops in memory:", GameData.planted_crops)
#
	#var tilemap: TileMapLayer = get_node("GameTileMap/Land&Sea")
	#print("Tilemap found:", tilemap)
	#if tilemap == null:
		#print("TileMap not found at GameTileMap/Land&Sea")
		#return
#
	#print("Loading crops:", GameData.planted_crops.size())
#
	#for crop_data in GameData.planted_crops:
		#var seed_name = str(crop_data.get("seed_name", ""))
		#print("Trying to load:", seed_name)
#
		#var crop_scene = GameData.get_seed_scene(seed_name)
		#print("Scene found:", crop_scene)
#
		#if crop_scene == null:
			#print("No scene for seed_name:", seed_name, " — skipping")
			#continue
#
		#var crop = crop_scene.instantiate()
		#print("Instantiated crop:", crop)
		#print("Getting crops parent…")
		#var crops_parent = GameData.get_crops_parent(self)
		#print("Got crops_parent:", crops_parent, "in tree?", crops_parent.is_inside_tree() if crops_parent else "null")
		#crops_parent.add_child(crop)
		#print("Added crop to parent")
#
		#print("Crop ready signal received")
#
		#var pos_array = crop_data["pos"]
		#var cell = Vector2i(int(pos_array[0]), int(pos_array[1]))
		#var tile_center = tilemap.map_to_local(cell) + Vector2(tilemap.tile_set.tile_size) / 2
		#crop.global_position = tilemap.to_global(tile_center)
#
		#crop.tilemap = tilemap
		#crop.seed_name = seed_name
		#crop.growth_cycle_component.current_growth_state = crop_data["growth_state"]
		#crop.growth_cycle_component.is_watered = crop_data["is_watered"]
		#crop.growth_cycle_component.starting_day = crop_data["starting_day"]
		#print("Placed", seed_name, "at cell", cell, "world pos", crop.global_position)
		
# test_scene_tilemap.gd
func load_crops():
	var tilemap: TileMapLayer = get_node("GameTileMap/Land&Sea")
	if tilemap == null:
		return

	var crops_parent = GameData.get_crops_parent(self)

	# Clear existing runtime crops to avoid carry-over
	for child in crops_parent.get_children():
		child.queue_free()
	print("Before load, planted_crops:", GameData.planted_crops.size())
	# Now spawn strictly from planted_crops
	for crop_data in GameData.planted_crops:
		print("  ", crop_data)
		var seed_name = str(crop_data.get("seed_name", ""))
		var crop_scene = GameData.get_seed_scene(seed_name)
		if crop_scene == null:
			continue

		var crop = crop_scene.instantiate()
		crops_parent.add_child(crop)

		var pos_array = crop_data["pos"]
		var cell = Vector2i(int(pos_array[0]), int(pos_array[1]))
		var tile_center = tilemap.map_to_local(cell) + Vector2(tilemap.tile_set.tile_size) / 2
		crop.global_position = tilemap.to_global(tile_center)

		crop.tilemap = tilemap
		crop.seed_name = seed_name
		crop.growth_cycle_component.current_growth_state = int(crop_data["growth_state"])
		crop.growth_cycle_component.is_watered = bool(crop_data["is_watered"])
		crop.growth_cycle_component.starting_day = int(crop_data["starting_day"])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_crops()
	BreedingManager.npcs = []
	breed_reset.emit()
	sfx_enter_scene.play()
	print("@Exit: Test Scen tm spawn point :", GameData.next_spawn)
	if GameData.next_spawn != "":
		var spawn_point = $Spawns.get_node(GameData.next_spawn)
		var player = $Player
		if spawn_point and player:
			player.global_position = spawn_point.global_position
			GameData.next_spawn = ""  # reset

func _exit_tree():
	# Force all crops to push their latest state to GameData before saving
	var crops_parent = GameData.get_crops_parent(self)
	for crop in crops_parent.get_children():
		crop.growth_cycle_component.save_crop_state()

	GameData.save_game()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
