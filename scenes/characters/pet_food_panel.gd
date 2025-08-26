extends Control

const SLOT_SCENE = preload("res://scenes/BerryMixer/slot.tscn")
@onready var grid_container = $Panel/ScrollContainer/PlayerFoodList
var inventory: Inv
signal pet_food_eaten
var pokemon

func _ready() -> void:
	visible = false
	
	GameData.player_entered.connect(_on_player_entered)
	print("signal connected 123")
	GameData.player_exited.connect(_on_player_exited)
		
	if GameData.inventory:
		_on_inventory_loaded()
	else:
		GameData.inventory_loaded.connect(_on_inventory_loaded)

func update_display():
	# Clear existing slots
	for child in grid_container.get_children():
		child.queue_free()
		
	# Create slot for each item in inventory
	for i in inventory.slots.size():
		var inv_slot: InvSlot = inventory.slots[i]
		if inv_slot.item and inv_slot.amount > 0 and inv_slot.item is PetFood:
			var slot = SLOT_SCENE.instantiate()
			#slot.custom_minimum_size = Vector2(100, 100)
			#slot.get_node("TextureRect").custom_minimum_size = Vector2(80, 80)
			grid_container.add_child(slot)
			

			slot.slot_clicked.connect(_on_inventory_slot_clicked)
			slot.set_data(inv_slot, i)

func _on_inventory_slot_clicked(slot: InvSlot, index: int):
	print("food clicked")
	pokemon.consume_pet_food(slot.item)
	GameData.inventory.remove(index)
	update_display()


func _on_inventory_loaded():
	inventory = GameData.inventory
	inventory.update.connect(update_display)
	update_display()

func _on_player_entered(poke):
	visible = true
	pokemon = poke

func _on_player_exited():
	visible = false
