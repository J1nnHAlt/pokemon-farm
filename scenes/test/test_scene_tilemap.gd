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

func load_crops():
	var tilemap: TileMapLayer = get_node("GameTileMap/Land&Sea")
	if tilemap == null:
		return

	var crops_parent = GameData.get_crops_parent(self)

	# Clear existing runtime crops to avoid duplicates
	for child in crops_parent.get_children():
		child.queue_free()

	# Spawn crops strictly from planted_crops
	for crop_data in GameData.planted_crops:
		var seed_name = crop_data["seed_name"]
		var crop_scene = GameData.get_seed_scene(seed_name)
		if crop_scene == null:
			continue

		var crop = crop_scene.instantiate()
		crops_parent.add_child(crop)

		var pos_array = crop_data["pos"]
		var cell = Vector2i(int(pos_array[0]), int(pos_array[1]))
		var tile_center = tilemap.map_to_local(cell) + Vector2(tilemap.tile_set.tile_size) / 2
		crop.global_position = tilemap.to_global(tile_center)

		# growth always starts fresh
		crop.tilemap = tilemap
		crop.seed_name = seed_name



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
	var crops_parent = GameData.get_crops_parent(self)
	for child in crops_parent.get_children():
		if child.has_node("GrowthCycleComponent"): # only save crops
			var tilemap = child.tilemap
			if tilemap:
				var cell = tilemap.local_to_map(tilemap.to_local(child.global_position))
				GameData.save_crop(
					cell,
					child.seed_name
				)

	GameData.save_game()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
