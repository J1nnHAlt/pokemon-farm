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

# Call this whenever the player sells a berry
func on_berry_sold() -> void:
	if already_spawned:
		return

	sold_berries += 1
	print("Berry sold, calling LegendaryManager (count =", sold_berries, ")")

	if sold_berries >= berries_required:
		sold_berries = 0  # reset counter so they must sell again next time

		var roll := rng.randf()
		print("Berry threshold reached, roll =", roll)
		if roll < chance:
			print("Roll succeeded, spawning legendary")
			_spawn_legendary()
		else:
			print("Roll failed, no spawn this time")
			_show_message("A strange feeling passes by... but nothing appeared.")


func _spawn_legendary() -> void:
	if legendary_scene == null:
		push_error("Legendary scene not assigned in Inspector!")
		print("ERROR: legendary_scene is null")
		return

	print("Step 1: Instantiating legendary...")
	var scene := legendary_scene.instantiate()
	print("Step 2: Legendary instantiated:", scene)

	var player := get_tree().get_first_node_in_group("player")
	print("Step 3: Player found:", player)
	if player and player is Node2D:
		var angle := rng.randf() * TAU
		var radius := rng.randf_range(64.0, spawn_radius)
		var offset := Vector2(cos(angle), sin(angle)) * radius
		scene.global_position = player.global_position + offset
		print("Step 4: Legendary position set to:", scene.global_position)
	else:
		scene.global_position = Vector2.ZERO
		print("Step 4: No player found, spawning at (0,0)")

	get_tree().current_scene.add_child(scene)
	print("Step 5: Legendary added to scene tree")

	already_spawned = true
	print("Step 6: Spawn complete ✅")

	_show_message("A Legendary Pokémon has appeared nearby!")


func _show_message(text: String) -> void:
	# TODO: Replace with your own UI system
	print(text)
