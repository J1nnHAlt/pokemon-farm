class_name Player
extends CharacterBody2D

@export var pokeball_scene = preload("res://scenes/pokeball/pokeball.tscn")
@onready var sfx_throw_pokeball: AudioStreamPlayer = $sfx_throw_pokeball
@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var inventory: Inv

@onready var interactButton: Control = $FButton
var current_interaction_source: Node = null

var _is_infront_water: bool = false

# Area2d that Check water is in front player
@onready var detection_area: Area2D = $DetectionArea

var _player_direction: Vector2 = Vector2.DOWN

var player_direction: Vector2:
	get:
		return _player_direction
	set(value):
		if value != Vector2.ZERO:
			_player_direction = value.normalized()
			_update_detection_position()

func _ready() -> void:
	add_to_group("player")
	set_inventory()
	GameData.inventory_loaded.connect(set_inventory)

	
func _process(delta):
	if Input.is_action_just_pressed("watering"):
		current_tool = DataTypes.Tools.WaterCrops
		$HitComponent.current_tool = current_tool
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

# Change the position of detection area according to player facing direction
func _update_detection_position() -> void:
	var offset = Vector2.ZERO
	if _player_direction == Vector2.UP:
		offset = Vector2(0, -22)
	elif _player_direction == Vector2.DOWN:
		offset = Vector2(0, 9)
	elif _player_direction == Vector2.LEFT:
		offset = Vector2(-15, -6)
	elif _player_direction == Vector2.RIGHT:
		offset = Vector2(15, -6)
	detection_area.position = offset

# check if the detection area enter collision layer 2 (water)
func _on_detection_area_body_entered(body: Node2D) -> void:
	_is_infront_water = true
	print("water entered")

func _on_detection_area_body_exited(body: Node2D) -> void:
	_is_infront_water = false
	print("water exited")

func is_water_in_front() -> bool:
	return _is_infront_water

# 
func set_interaction_source(source: Node, visible: bool) -> void:
	# If a new source registers
	if source != null:
		current_interaction_source = source
		interactButton.visible = visible
	# If source clears itself
	elif source == current_interaction_source:
		current_interaction_source = null
		interactButton.visible = false
