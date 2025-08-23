extends Area2D

@export var item_name: String = "Berry"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"): # make sure your player is in a "player" group
		body.collect(item_name) # calls Player.collect(item)
		queue_free()
