extends Node

var legendary_scene: PackedScene = preload("res://scenes/legendary_pokemon/legendary.tscn")         # assign your LegendaryPokemon.tscn in Inspector
@export var berries_required: int = 10            # how many berries to sell
@export var spawn_radius: float = 128.0           # how close to spawn around player
@export var chance: float = 1.0                   # 100% chance right now (set to 0.5 for 50%)

var sold_berries: int = 0
var already_spawned: bool = false
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func on_berry_sold() -> void:
	if already_spawned:
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

	already_spawned = true
	_show_message("A Legendary Pokémon has appeared nearby!")

func _show_message(text: String) -> void:
	# TODO: Replace with your own UI system
	print(text)
