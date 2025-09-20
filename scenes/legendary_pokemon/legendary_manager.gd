extends Node

var legendary_scene: PackedScene = preload("res://scenes/legendary_pokemon/legendary.tscn")
@export var berries_required: int = 10
@export var spawn_radius: float = 128.0
@export var chance: float = 1.0

var sold_berries: int = 0
var already_spawned: bool = false
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

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
	if legendary_scene == null:
		push_error("Legendary scene not assigned in Inspector!")
		return

	var player := get_tree().get_first_node_in_group("player")
	if not player:
		print("No player found, cannot spawn legendary")
		return

	if not player.get_parent() or player.get_parent().name != "dungeon":
		_show_message("You sense a powerful presence... but it fades away.")
		return

	var scene := legendary_scene.instantiate()

	var angle := rng.randf() * TAU
	var radius := rng.randf_range(64.0, spawn_radius)
	var offset := Vector2(cos(angle), sin(angle)) * radius
	scene.global_position = player.global_position + offset

	get_tree().current_scene.add_child(scene)
	print("Legendary spawned at:", scene.global_position)

	_show_message("A Legendary Pokémon has appeared nearby!")
	_apply_legendary_buff()


func _apply_legendary_buff() -> void:
	var crops := get_tree().get_nodes_in_group("crops") # <-- add your crops to this group in the editor
	for crop in crops:
		var growth := crop.get_node_or_null("GrowthCycleComponent") # adjust path if needed
		if growth:
			growth.days_until_harvest = 3
			print("Buff applied to:", crop.name)


func _show_message(text: String) -> void:
	# implement UI system here
	print(text)
