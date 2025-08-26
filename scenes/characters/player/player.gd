class_name Player
extends CharacterBody2D

@export var pokeball_scene = preload("res://scenes/pokeball/pokeball.tscn")
@onready var sfx_throw_pokeball: AudioStreamPlayer = $sfx_throw_pokeball
@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var inventory: Inv
var pokeball_cd: bool = false

@onready var interaction_ray: RayCast2D = $DoorDetector
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
	
	if GameData.next_spawn != "":
		var spawn_point = get_tree().current_scene.get_node_or_null(GameData.next_spawn)
		if spawn_point:
			global_position = spawn_point.global_position
			print("@Spawn: Player placed at", global_position)
		else:
			push_warning("@Spawn: Could not find spawn point: %s" % GameData.next_spawn)

		# Clear it so it doesn’t keep reusing
		GameData.next_spawn = ""

	
func _process(delta):
	if Input.is_action_just_pressed("watering"):
		current_tool = DataTypes.Tools.WaterCrops
		$HitComponent.current_tool = current_tool
		print("Tool changed to: ", current_tool)
	
	if get_parent().name == 'dungeon':
		if Input.is_action_just_pressed("throw_pokeball") and !pokeball_cd:
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
	$pokeball_cd.start(1.5)
	pokeball_cd = true

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

# Update ray direction based on player_direction
func update_interaction_ray():
	match player_direction:
		Vector2.UP:
			interaction_ray.target_position = Vector2(0, -8)
		Vector2.DOWN:
			interaction_ray.target_position = Vector2(0, 8)
		Vector2.LEFT:
			interaction_ray.target_position = Vector2(-8, 0)
		Vector2.RIGHT:
			interaction_ray.target_position = Vector2(8, 0)

# Detect if door is in front of player
func detect_door() -> Node:
	if interaction_ray.is_colliding():
		var hit = interaction_ray.get_collider()
		if hit and hit is CollisionObject2D:
			# Check if collider is on physics layer 11
			if hit.get_collision_layer_value(9):
				print("@Door: Door detected")
				return hit
	return null

# This fucntion will check if the raycast2d collide with Door or not, if yes then return the Door object
func get_door_in_front() -> Door:
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		if collider is Door:
			print("@Door: get_door_in_front triggered")
			return collider
	return null


func _on_pokeball_cd_timeout() -> void:
	pokeball_cd = false
