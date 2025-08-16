# Pokeball.gd (attached to your Pokeball scene)
extends Area2D

@export var speed: float = 400.0
var velocity: Vector2

func _physics_process(delta):
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
