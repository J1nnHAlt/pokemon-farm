extends Node2D
@onready var sfx_enter_scene: AudioStreamPlayer = $sfx_enter_scene

signal breed_reset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BreedingManager.npcs = []
	breed_reset.emit()
	sfx_enter_scene.play()
	print("@Exit: Test Scen tm spawn point :", GameData.next_spawn)
	if GameData.next_spawn != "":
		var spawn_point = $Spawns.get_node(GameData.next_spawn)
		var player = $Player
		if spawn_point and player:
			player.global_position = spawn_point.global_position
			GameData.next_spawn = ""  # reset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
