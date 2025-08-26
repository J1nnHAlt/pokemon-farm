extends Area2D
class_name EntrancePoint

@export var linked_door_id: String   # matches the outside Door’s id

signal player_entered

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_entered", body)
		print("@Entrance: Player entered")
