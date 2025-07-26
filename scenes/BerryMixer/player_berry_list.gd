#extends GridContainer
#
#var player_inventory = {
	#"CheriBerry": {"id": "001", "name": "CheriBerry", "texture": preload("res://pokemon-assets/Graphics/Items/CHERIBERRY.png"), "amount": 3}, 
	#"PamtreBerry": {"id": "002", "name": "PamtreBerry", "texture": preload("res://pokemon-assets/Graphics/Items/PAMTREBERRY.png"), "amount": 5}, 
	#"DurinBerry": {"id": "003", "name": "DurinBerry", "texture": preload("res://pokemon-assets/Graphics/Items/DURINBERRY.png"), "amount": 1}
#}
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#update_inventory()
#
#func update_inventory():
	#for child in self.get_children():
		#child.queue_free()
		#
	#for berry in player_inventory:
		#var slot = preload("res://scenes/BerryMixer/berry_slot.tscn").instantiate()
		#slot.set_berry_data(player_inventory[berry])
		#add_child(slot)
#
#func _process(float):
	#for child in self.get_children():
		#player_inventory[child.berry_data.name].amount = child.berry_data.amount
		#if child.berry_data.amount <=0:
			#self.remove_child(child)

extends GridContainer

const SLOT_SCENE = preload("res://scenes/BerryMixer/slot.tscn") # Path to your new slot scene

func _ready() -> void:
	InventoryManager.inventory_updated.connect(update_display)
	update_display()

func update_display():
	# Clear existing slots
	for child in get_children():
		child.queue_free()
		
	# Create a slot for each berry type the player has
	for berry_name in InventoryManager.player_inventory:
		var berry_data = InventoryManager.player_inventory[berry_name]
		if berry_data.amount > 0:
			var slot = SLOT_SCENE.instantiate()
			
			# 1. ADD THE SLOT TO THE SCENE TREE FIRST
			add_child(slot)
			
			# 2. NOW it's safe to connect signals and set data
			slot.slot_clicked.connect(_on_inventory_slot_clicked)
			slot.set_data(berry_data)

# When an inventory slot is clicked, try to add it to the mixer
func _on_inventory_slot_clicked(data: Dictionary):
	if InventoryManager.remove_item(data.name, 1):
		# Make sure this path is correct for your scene structure
		get_node("/root/BerryMixer/HBoxContainer/MixerPanel/PanelContainer/MixerContent").add_item(data)
