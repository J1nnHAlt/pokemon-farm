class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var inventory: Inv

var player_direction: Vector2

func _ready() -> void:
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("watering"):
		current_tool = DataTypes.Tools.WaterCrops
		print("Tool changed to: ", current_tool)
		
#to be called when collecting item
func collect(item):
	return inventory.insert(item)
