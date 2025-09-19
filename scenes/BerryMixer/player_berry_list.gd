extends GridContainer

const SLOT_SCENE = preload("res://scenes/BerryMixer/slot.tscn") 
var inventory: Inv

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
		if inv_slot.item and inv_slot.amount > 0 and inv_slot.item is not PetFood and inv_slot.item is not SeedItem and inv_slot.item.name != "Pokeball":
			var slot = SLOT_SCENE.instantiate()
			add_child(slot)

			slot.slot_clicked.connect(_on_inventory_slot_clicked)
			slot.set_data(inv_slot, i)

func _on_inventory_slot_clicked(slot: InvSlot, index: int):
	get_node("/root/BerryMixer/HBoxContainer/MixerPanel/PanelContainer/MixerContent").add_item(slot.item)
	print("slot.item: ", slot.item)
	GameData.inventory.remove(index)
	update_display()


func _on_inventory_loaded():
	inventory = GameData.inventory
	print("signal received")
	inventory.update.connect(update_display)
	update_display()
	print("update display called in ready")
