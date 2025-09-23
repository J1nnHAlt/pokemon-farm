extends Node2D
var player_nearby := false

@export var mixer_ui_scene: PackedScene = preload("res://scenes/BerryMixer/berry_mixer.tscn")
@export var mixer_scene = "res://scenes/BerryMixer/berry_mixer.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(mixer_scene)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = true
		body.set_interaction_source(self, true)  # Register seller as interaction source


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = false
		body.set_interaction_source(self, false)  # Register seller as interaction source
