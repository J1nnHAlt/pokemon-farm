class_name Player
extends CharacterBody2D

@export var pokeball_scene = preload("res://scenes/pokeball/pokeball.tscn")
@onready var sfx_throw_pokeball: AudioStreamPlayer = $sfx_throw_pokeball

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var inventory: Inv

var player_direction: Vector2

func _ready() -> void:
	set_inventory()
	GameData.inventory_loaded.connect(set_inventory)

	
func _process(delta):
	if Input.is_action_just_pressed("watering"):
		current_tool = DataTypes.Tools.WaterCrops
		print("Tool changed to: ", current_tool)
		
	if Input.is_action_just_pressed("throw_pokeball"):
		throw_pokeball()
#to be called when collecting item
func collect(item):
	return inventory.insert(item)

func set_inventory():
	inventory = GameData.inventory

func throw_pokeball():
	sfx_throw_pokeball.play()
	var pokeball = pokeball_scene.instantiate()
	get_parent().add_child(pokeball)
	pokeball.global_position = global_position
	
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	pokeball.velocity = dir * pokeball.speed
