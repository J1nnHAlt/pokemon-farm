extends Control

#@onready var inv: Inv = preload("res://scripts/inventory/player_inv.tres")
@onready var inv: Inv = GameData.inventory
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var sfx_open_menu: AudioStreamPlayer = $sfx_open_menu
@onready var sfx_close_menu: AudioStreamPlayer = $sfx_close_menu

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
#	loop through all slots and update them
		for i in range(min(inv.slots.size(), slots.size())):
			slots[i].update(inv.slots[i], i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			sfx_close_menu.play()
			close()
		else:
			sfx_open_menu.play()
			open()

func open():
	#var hud_layer = get_tree().get_first_node_in_group("hud_layer")
	#if hud_layer:
		#hud_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#hud_layer.visible = false
	set_hud_input(false)
	visible = true
	is_open = true

func close():
	#var hud_layer = get_tree().get_first_node_in_group("hud_layer")
	#if hud_layer:
		#hud_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#hud_layer.visible = true
	set_hud_input(true)
	visible = false
	is_open = false
	
func set_hud_input(enabled: bool):
	var hud_layer = get_tree().get_first_node_in_group("hud_layer")
	if hud_layer:
		for child in hud_layer.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
