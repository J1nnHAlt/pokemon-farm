extends Node
class_name LegendarySystem

@export var legendary_scene: PackedScene
@export var berries_required: int = 10     # how many berries needed before spawn check
@export var spawn_radius: float = 128.0
@export var chance: float = 0.3            # 30% chance per trigger

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	add_to_group("legendary_system")  # so NPC can find this


func on_berry_sold() -> void:
	if GameData.total_berries_sold % berries_required == 0:
		var roll := rng.randf()
		if roll < chance:
			_spawn_legendary()
		else:
			_show_message("A strange feeling passes by... but nothing appeared.")


func _spawn_legendary() -> void:
	if not legendary_scene:
		push_error("Legendary scene not assigned!")
		return

	var player := get_tree().get_first_node_in_group("player")
	if not player:
		print("No player found, cannot spawn legendary")
		return

	var scene := legendary_scene.instantiate()
	var angle := rng.randf() * TAU
	var radius := rng.randf_range(64.0, spawn_radius)
	var offset := Vector2(cos(angle), sin(angle)) * radius
	scene.global_position = player.global_position + offset

	get_tree().current_scene.add_child(scene)
	print("Legendary spawned at:", scene.global_position)

	_show_message("A Legendary Pokémon has appeared nearby!")


func _show_message(text: String) -> void:
	print(text)  # Replace later with your UI system
