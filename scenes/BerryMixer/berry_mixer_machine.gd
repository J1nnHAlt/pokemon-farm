extends Node2D
var player_nearby := false

@export var mixer_ui_scene: PackedScene = preload("res://scenes/BerryMixer/berry_mixer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		var ui = mixer_ui_scene.instantiate()
		get_tree().root.add_child(ui)  # add to UI layer (root or a CanvasLayer)
		ui.visible = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = true
		body.set_interaction_source(self, true)  # Register seller as interaction source


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = false
		body.set_interaction_source(self, false)  # Register seller as interaction source
