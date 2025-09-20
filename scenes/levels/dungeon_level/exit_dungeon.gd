extends Area2D

@export var main_scene = "res://scenes/test/test_scene_tilemap.tscn"
@export var target_spawn: String = "DungeonExitSpawn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		GameData.next_spawn = target_spawn
		GameData.save_time()
		print("@Exit: GameData.next_spawn =", GameData.next_spawn)
		get_tree().call_deferred("change_scene_to_file", main_scene)
