class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
	add_to_group("player")
