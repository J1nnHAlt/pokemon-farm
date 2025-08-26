#extends GridContainer
#
#const SLOT_SCENE = preload("res://scenes/BerryMixer/slot.tscn") # Path to your new slot scene
#var inventory = GameData.inventory
#
#func _ready() -> void:
	##InventoryManager.inventory_updated.connect(update_display)
	#inventory.update.connect(update_display())
	#update_display()
#
#func update_display():
	## Clear existing slots
	#for child in get_children():
		#child.queue_free()
		#
	## Create a slot for each berry type the player has
	##for berry_name in InventoryManager.player_inventory:
		##var berry_data = InventoryManager.player_inventory[berry_name]
		##if berry_data.amount > 0 and berry_data.texture:
			##var slot = SLOT_SCENE.instantiate()
			##
			### 1. ADD THE SLOT TO THE SCENE TREE FIRST
			##add_child(slot)
			##
			### 2. NOW it's safe to connect signals and set data
			##slot.slot_clicked.connect(_on_inventory_slot_clicked)
			##slot.set_data(berry_data)
			#
	#for inv_slot in inventory.slots:
		#if inv_slot.amount > 0:
			#var slot = SLOT_SCENE.instantiate()
			#
			## 1. ADD THE SLOT TO THE SCENE TREE FIRST
			#add_child(slot)
			#
			## 2. NOW it's safe to connect signals and set data
			#slot.slot_clicked.connect(_on_inventory_slot_clicked)
			#slot.set_data(inv_slot)
#
## When an inventory slot is clicked, try to add it to the mixer
#func _on_inventory_slot_clicked(data: Dictionary):
	#if InventoryManager.remove_item(data.name, 1):
		## Make sure this path is correct for your scene structure
		#get_node("/root/BerryMixer/HBoxContainer/MixerPanel/PanelContainer/MixerContent").add_item(data)


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
		if inv_slot.item and inv_slot.amount > 0 and inv_slot.item is not PetFood:
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
