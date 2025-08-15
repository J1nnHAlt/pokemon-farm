extends Control

#@onready var inv: Inv = preload("res://scripts/inventory/player_inv.tres")
@onready var inv: Inv = GameData.inventory
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
#	loop through all slots and update them
		for i in range(min(inv.slots.size(), slots.size())):
			slots[i].update(inv.slots[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
