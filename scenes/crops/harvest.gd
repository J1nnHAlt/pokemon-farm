extends Area2D

@export var item: InvItem
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if item:
		sprite.texture = item.texture
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Collided with: ", body.name)
		body.collect(item)
		queue_free()
