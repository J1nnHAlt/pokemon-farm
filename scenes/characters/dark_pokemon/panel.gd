extends Panel

const SLOT_SCENE = preload("res://scenes/BerryMixer/slot.tscn") 
var inventory: Inv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.inventory:
		_on_inventory_loaded()
	else:
		GameData.inventory_loaded.connect(_on_inventory_loaded)

func update_display():
	# Clear existing slots
	for child in get_children():
		child.queue_free()
		
	# Create slot for each item in inventory
	for i in inventory.slots.size():
		var inv_slot: InvSlot = inventory.slots[i]
		if inv_slot.item and inv_slot.amount > 0 and inv_slot.item is not PetFood:
			var slot = SLOT_SCENE.instantiate()
			add_child(slot)

			slot.slot_clicked.connect(_on_inventory_slot_clicked)
			slot.set_data(inv_slot, i)

func _on_inventory_loaded():
	inventory = GameData.inventory
	inventory.update.connect(update_display)
	update_display()
