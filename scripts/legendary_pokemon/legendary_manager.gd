extends Node

var legendary_scene: PackedScene = preload("res://scenes/legendary_pokemon/legendary.tscn")
@export var berries_required: int = 10
@export var spawn_radius: float = 128.0
@export var chance: float = 1.0
@export var lifetime_days: int = 15  # how long legendary stays

var sold_berries: int = 0
var rng := RandomNumberGenerator.new()

signal legendary_activated
signal legendary_deactivated

var legendary_instance: Node = null
var spawn_day: int = -1
var legendary_active: bool = false 


func activate_legendary():
	legendary_active = true
	emit_signal("legendary_activated")

func deactivate_legendary():
	legendary_active = false
	emit_signal("legendary_deactivated")
	
func _ready() -> void:
	add_to_group("legendary_manager")
	rng.randomize()
	DayAndNightCycleManager.time_tick_day.connect(_on_day_changed) # signal from your day/night system

func on_berry_sold() -> void:
	if legendary_instance:
		return

	sold_berries += 1

	if sold_berries >= berries_required:
		sold_berries = 0  # reset counter so they must sell again next time

		var roll := rng.randf()
		if roll < chance:
			_spawn_legendary()
		else:
			_show_message("A strange feeling passes by... but nothing appeared.")

func _spawn_legendary() -> void:
	if legendary_instance: return
	legendary_instance = legendary_scene.instantiate()
	get_tree().current_scene.add_child(legendary_instance)
	spawn_day = DayAndNightCycleManager.current_day
	legendary_active = true
	emit_signal("legendary_activated")
	print("Legendary spawned!")

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
	legendary_instance = legendary_scene.instantiate()
	var angle := rng.randf() * TAU
	var radius := rng.randf_range(64.0, spawn_radius)
	var offset := Vector2(cos(angle), sin(angle)) * radius
	legendary_instance.global_position = player.global_position + offset

	current_scene.add_child(legendary_instance)
	spawn_day = DayAndNightCycleManager.current_day  # mark spawn day

	print("Legendary spawned at:", legendary_instance.global_position)
	_show_message("A Legendary Pokémon has appeared nearby!")

	_apply_legendary_buff()

func _apply_legendary_buff() -> void:
	var crops := get_tree().get_nodes_in_group("crops")
	for crop in crops:
		var growth := crop.get_node_or_null("GrowthCycleComponent")
		if growth:
			# reset timer + shorten harvest duration
			growth.starting_day = DayAndNightCycleManager.current_day
			growth.days_until_harvest = 5
			print("Buff applied to:", crop.name)

func _on_day_changed(day: int) -> void:
	if legendary_instance and spawn_day >= 0:
		if day - spawn_day >= lifetime_days:
			legendary_instance.queue_free()
			legendary_instance = null
			spawn_day = -1
			legendary_active = false
			emit_signal("legendary_deactivated")
			print("Legendary despawned after", lifetime_days, "days")

func _show_message(text: String) -> void:
	print(text)
