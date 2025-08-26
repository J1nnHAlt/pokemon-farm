extends Area2D
class_name EntrancePoint

@export var target_scene: String = "res://scenes/test/test_scene_tilemap.tscn"
@export var target_spawn: String = ""  # name of the Spawn node in main world
@onready var player: Player = $Player

signal player_entered

func _ready() -> void:
	body_entered.connect(_on_body_entered)
		
	var anim_sprite := player.get_node_or_null("AnimatedSprite2D")
	if anim_sprite:
		anim_sprite.play("idle_back")
		print("@Exit: Player set to idle_back animation")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		print("@Exit: Player entered exit area")

		# Save spawn target
		GameData.next_spawn = target_spawn
		print("@Exit: GameData.next_spawn =", GameData.next_spawn)

		# Change to outside scene
		get_tree().change_scene_to_file(target_scene)
		print("@Exit: Changed scene to", target_scene)
