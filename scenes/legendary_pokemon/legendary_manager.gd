extends Node

@export var legendary_scene: PackedScene          # assign your LegendaryPokemon.tscn in Inspector
@export var berries_required: int = 10            # how many berries to sell
@export var spawn_radius: float = 128.0           # how close to spawn around player
@export var chance: float = 1.0                   # 50% chance

var sold_berries: int = 0
var already_spawned: bool = false
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

# Call this whenever the player sells a berry
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
	var scene := legendary_scene.instantiate()

	var player := get_tree().get_first_node_in_group("player")
	if player and player is Node2D:
		var angle := rng.randf() * TAU
		var radius := rng.randf_range(64.0, spawn_radius)
		var offset := Vector2(cos(angle), sin(angle)) * radius
		scene.global_position = player.global_position + offset
	else:
		scene.global_position = Vector2.ZERO

	get_tree().current_scene.add_child(scene)
	already_spawned = true
	_show_message("A Legendary Pokémon has appeared nearby!")


func _show_message(text: String) -> void:
	# TODO: Replace with your own UI system
	print(text)
