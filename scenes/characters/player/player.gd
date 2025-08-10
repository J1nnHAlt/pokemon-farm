class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var inventory: Inv

var player_direction: Vector2

func _ready() -> void:
	pass

#to be called when collecting item
func collect(item):
	inventory.insert(item)
