class_name Player
extends CharacterBody2D

@export var pokeball_scene = preload("res://scenes/pokeball/pokeball.tscn")
@onready var sfx_throw_pokeball: AudioStreamPlayer = $sfx_throw_pokeball
@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var inventory: Inv
var selected_seed: PackedScene = null
var pokeball_cd: bool = false

@export var fishing_rod_level: int = 0 # starts at 0, can upgrade to 1–3

@onready var interaction_ray: RayCast2D = $DoorDetector
@onready var interactButton: Control = $FButton
var current_interaction_source: Node = null

var _is_infront_water: bool = false
var can_move: bool = true

# Area2d that Check water is in front player
@onready var detection_area: Area2D = $DetectionArea

var _player_direction: Vector2 = Vector2.DOWN

var player_direction: Vector2:
	get:
		return _player_direction
	set(value):
		if value != Vector2.ZERO:
			_player_direction = value.normalized()
			_update_detection_position()

func _ready() -> void:
	add_to_group("player")
	set_inventory()
	GameData.inventory_loaded.connect(set_inventory)
	fishing_rod_level = GameData.fishing_rod_level
	
	# Connect to dialog manager
	var dm = get_tree().get_first_node_in_group("dialog_manager")
	if dm:
		dm.choice_active.connect(_on_choice_active)

	
func _process(delta):
	if Input.is_action_just_pressed("watering"):
		current_tool = DataTypes.Tools.WaterCrops
		$HitComponent.current_tool = current_tool
		print("Tool changed to: ", current_tool)
	
	if Input.is_action_just_pressed("interact") and current_interaction_source:
		if current_interaction_source.has_method("start_dialog"):
			var dialog_manager = get_tree().get_first_node_in_group("dialog_manager")
			if dialog_manager and not dialog_manager.visible:
				current_interaction_source.start_dialog()

	if get_parent().name == 'dungeon':
		if Input.is_action_just_pressed("throw_pokeball") and !pokeball_cd:
			if inventory.checkAmount("Pokeball") > 0:
				throw_pokeball()
				inventory.remove(inventory.search("Pokeball"))
	$pokeball_cd_bar.value = $pokeball_cd.time_left

#to be called when collecting item
func collect(item):
	return inventory.insert(item)

func set_inventory():
	inventory = GameData.inventory

func throw_pokeball():
	sfx_throw_pokeball.play()
	var pokeball = pokeball_scene.instantiate()
	get_parent().add_child(pokeball)
	pokeball.global_position = global_position
	
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	pokeball.velocity = dir * pokeball.speed
	$pokeball_cd.start(1.5)
	pokeball_cd = true
	$pokeball_cd_bar.visible = true

# Change the position of detection area according to player facing direction
func _update_detection_position() -> void:
	var offset = Vector2.ZERO
	if _player_direction == Vector2.UP:
		offset = Vector2(0, -22)
	elif _player_direction == Vector2.DOWN:
		offset = Vector2(0, 9)
	elif _player_direction == Vector2.LEFT:
		offset = Vector2(-15, -6)
	elif _player_direction == Vector2.RIGHT:
		offset = Vector2(15, -6)
	detection_area.position = offset

# check if the detection area enter collision layer 2 (water)
func _on_detection_area_body_entered(body: Node2D) -> void:
	_is_infront_water = true
	print("water entered")

func _on_detection_area_body_exited(body: Node2D) -> void:
	_is_infront_water = false
	print("water exited")

func is_water_in_front() -> bool:
	return _is_infront_water

# 
func set_interaction_source(source: Node, visible: bool) -> void:
	# If a new source registers
	if source != null:
		current_interaction_source = source
		interactButton.visible = visible
	# If source clears itself
	elif source == current_interaction_source:
		current_interaction_source = null
		interactButton.visible = false

# Update ray direction based on player_direction
func update_interaction_ray():
	match player_direction:
		Vector2.UP:
			interaction_ray.target_position = Vector2(0, -8)
		Vector2.DOWN:
			interaction_ray.target_position = Vector2(0, 8)
		Vector2.LEFT:
			interaction_ray.target_position = Vector2(-8, 0)
		Vector2.RIGHT:
			interaction_ray.target_position = Vector2(8, 0)

# Detect if door is in front of player
func detect_door() -> Node:
	if interaction_ray.is_colliding():
		var hit = interaction_ray.get_collider()
		if hit and hit is CollisionObject2D:
			# Check if collider is on physics layer 11
			if hit.get_collision_layer_value(9):
				print("@Door: Door detected")
				return hit
	return null

# This fucntion will check if the raycast2d collide with Door or not, if yes then return the Door object
func get_door_in_front() -> Door:
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		if collider is Door:
			print("@Door: get_door_in_front triggered")
			return collider
	return null

func play_surf_overlay():
		# Load the overlay scene
	var overlay = preload("res://scenes/UI/surf_overlay.tscn").instantiate()
	# Add overlay to the current scene (to the top level, not as a child of player)
	get_tree().current_scene.add_child(overlay)
	# Start playing animation
	overlay.play_overlay()

func upgrade_fishing_rod():
	if fishing_rod_level < 3:
		fishing_rod_level += 1
		GameData.fishing_rod_level = fishing_rod_level

func _on_choice_active(active: bool) -> void:
	if active:
		can_move = false
		print("@Dialog: Player Disabled movement because dialog choice is active")
	else:
		can_move = true
		print("@Dialog: Player Re-enabled movement after dialog choice")

func _on_pokeball_cd_timeout() -> void:
	pokeball_cd = false
	$pokeball_cd_bar.visible = false
	
func set_selected_seed(seed_scene: PackedScene):
	selected_seed = seed_scene
	print("Selected seed:", selected_seed)
	
func plant_seed(seed: SeedItem, slot_index: int):
	if not seed or not seed.crop_scene:
		return

	var tilemap: TileMapLayer = get_node("../GameTileMap/Land&Sea")
	if tilemap == null:
		return

	# Get the detection area's global position (already offset in front of player)
	var target_cell: Vector2i = tilemap.local_to_map(tilemap.to_local(detection_area.global_position))

	var tile_data: TileData = tilemap.get_cell_tile_data(target_cell)
	if tile_data and tile_data.get_custom_data("plantable"):
		var crop = seed.crop_scene.instantiate()
		get_parent().add_child(crop)

		var tile_center_local = tilemap.map_to_local(target_cell) + Vector2(tilemap.tile_set.tile_size) / 2
		crop.global_position = tilemap.to_global(tile_center_local)
		GameData.save_crop(
			target_cell,                            # tile position
			seed.name,                              # seed name
			DataTypes.GrowthStates.Seed,            # initial growth state
			false,                                  # not watered yet
			DayAndNightCycleManager.current_day     # starting day
		)
		GameData.inventory.remove(slot_index)
		GameData.save_game()
		print("Planted ", seed.name, " at ", target_cell)
	else:
		print("Can't plant here")
