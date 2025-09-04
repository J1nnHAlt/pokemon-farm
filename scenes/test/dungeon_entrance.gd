extends Area2D

@export var dungeon_scene: String = "res://scenes/levels/dungeon_level/dungeon.tscn"
@export var target_spawn: String = "DungeonExitSpawn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.name == "Player" or body.is_in_group("player"):
		GameData.next_spawn = target_spawn
#		call deferred to avoid deleting physics objects whil physics is still processing
		get_tree().call_deferred("change_scene_to_file", dungeon_scene)
	pass # Replace with function body.
