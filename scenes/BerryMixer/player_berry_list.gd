extends VBoxContainer

@export var player_inventory = [
	{"id": "001", "name": "CheriBerry", "icon": preload("res://pokemon-assets/Graphics/Items/CHERIBERRY.png"), "amount": 3}, 
	{"id": "002", "name": "PamtreBerry", "icon": preload("res://pokemon-assets/Graphics/Items/PAMTREBERRY.png"), "amount": 5}, 
	{"id": "003", "name": "DurinBerry", "icon": preload("res://pokemon-assets/Graphics/Items/DURINBERRY.png"), "amount": 1}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory()

func update_inventory():
	for child in self.get_children():
		child.queue_free()
		
	for berry in player_inventory:
		var slot = preload("res://scenes/BerryMixer/berry_slot.tscn").instantiate()
		slot.set_berry_data(berry)	
		add_child(slot)
