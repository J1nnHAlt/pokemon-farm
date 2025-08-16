extends Node2D
@onready var sfx_enter_scene: AudioStreamPlayer = $sfx_enter_scene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_enter_scene.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
