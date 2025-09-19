extends Node2D
@onready var sfx_enter_scene: AudioStreamPlayer = $sfx_enter_scene

signal breed_reset

func load_crops():
	var tilemap: TileMapLayer = get_node("../GameTileMap/Land&Sea")
	for crop_data in GameData.planted_crops:
		var crop_scene = GameData.get_seed_scene(crop_data.seed_name)
		if crop_scene:
			var crop = crop_scene.instantiate()
			add_child(crop)

			var cell = crop_data.pos
			var tile_center = tilemap.map_to_local(cell) + Vector2(tilemap.tile_set.tile_size) / 2
			crop.global_position = tilemap.to_global(tile_center)

			# Restore growth state and watering
			crop.growth_state = crop_data.growth_state
			crop.growth_cycle_component.current_growth_state = crop_data.growth_state
			crop.growth_cycle_component.is_watered = crop_data.is_watered
			crop.growth_cycle_component.starting_day = crop_data.starting_day
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
