extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	visible = false
	# Connect the signal so we know when visibility changes
	self.connect("visibility_changed", Callable(self, "_on_visibility_changed"))

func _on_visibility_changed() -> void:
	if visible:
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()
