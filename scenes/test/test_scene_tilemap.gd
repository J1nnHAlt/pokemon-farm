extends Node2D
@onready var sfx_enter_scene: AudioStreamPlayer = $sfx_enter_scene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_enter_scene.play()
	if GameData.next_spawn != "":
		var spawn_point = $Spawns.get_node(GameData.next_spawn)
		var player = $Player
		if spawn_point and player:
			player.global_position = spawn_point.global_position
		GameData.next_spawn = ""  # reset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
