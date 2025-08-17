extends Area2D

@export var main_scene = "res://scenes/test/test_scene_tilemap.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("in dungeon entered")
	if body.is_in_group("player") or body.name == "Player":
		print("in dungeon true")
		get_tree().change_scene_to_file(main_scene)
	print("in dungeon false")
