extends Node

var legendary_scene: PackedScene = preload("res://scenes/legendary_pokemon/legendary.tscn")
@export var berries_required: int = 10
@export var spawn_radius: float = 128.0
@export var chance: float = 1.0

var sold_berries: int = 0
var rng := RandomNumberGenerator.new()

var active_legendary: Node = null
var spawn_day: int = -1
@export var lifetime_days: int = 15  # how long legendary stays

func _ready() -> void:
	rng.randomize()
	DayAndNightCycleManager.day_changed.connect(_on_day_changed) # signal from your day/night system

func on_berry_sold() -> void:
	sold_berries += 1

	if sold_berries >= berries_required:
		sold_berries = 0  # reset counter so they must sell again next time

		var roll := rng.randf()
		if roll < chance:
			_spawn_legendary()
		else:
			_show_message("A strange feeling passes by... but nothing appeared.")

func _spawn_legendary() -> void:
	if active_legendary:
		print("Legendary already spawned, skipping.")
		return

	if legendary_scene == null:
		push_error("Legendary scene not assigned in Inspector!")
		return

	# Check scene restriction
	var current_scene := get_tree().current_scene
	if not current_scene or current_scene.name != "TestSceneTilemap":
		_show_message("You sense a powerful presence... but it fades away.")
		return

	var player := get_tree().get_first_node_in_group("player")
	if not player:
		print("No player found, cannot spawn legendary")
		return

	# Spawn near player
	var scene := legendary_scene.instantiate()
	var angle := rng.randf() * TAU
	var radius := rng.randf_range(64.0, spawn_radius)
	var offset := Vector2(cos(angle), sin(angle)) * radius
	scene.global_position = player.global_position + offset

	current_scene.add_child(scene)
	active_legendary = scene
	spawn_day = DayAndNightCycleManager.current_day  # mark spawn day

	print("Legendary spawned at:", scene.global_position)
	_show_message("A Legendary Pokémon has appeared nearby!")

	_apply_legendary_buff()

func _apply_legendary_buff() -> void:
	var crops := get_tree().get_nodes_in_group("crops")
	for crop in crops:
		var growth := crop.get_node_or_null("GrowthCycleComponent")
		if growth:
			growth.days_until_harvest = 3
			print("Buff applied to:", crop.name)

func _on_day_changed(new_day: int) -> void:
	if active_legendary and spawn_day > 0:
		if new_day - spawn_day >= lifetime_days:
			print("Legendary has faded away after", lifetime_days, "days.")
			active_legendary.queue_free()
			active_legendary = null
			spawn_day = -1
			_show_message("The Legendary Pokémon has disappeared...")

func _show_message(text: String) -> void:
	# implement UI system here
	print(text)
