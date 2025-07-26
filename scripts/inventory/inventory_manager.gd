extends Node

# Signal to notify UI when the inventory changes
signal inventory_updated

# The single source of truth for player's berries
var player_inventory = {
	"CheriBerry": {"id": "001", "name": "CheriBerry", "texture": preload("res://pokemon-assets/Graphics/Items/CHERIBERRY.png"), "amount": 3},
	"PamtreBerry": {"id": "002", "name": "PamtreBerry", "texture": preload("res://pokemon-assets/Graphics/Items/PAMTREBERRY.png"), "amount": 5},
	"DurinBerry": {"id": "003", "name": "DurinBerry", "texture": preload("res://pokemon-assets/Graphics/Items/DURINBERRY.png"), "amount": 1}
}

# Function to add an item back to inventory
func add_item(item_name: String, amount: int = 1):
	if player_inventory.has(item_name):
		player_inventory[item_name].amount += amount
	# Optionally, handle adding a new item type if it doesn't exist
	# else:
	# 	# logic to add a completely new berry type
	
	inventory_updated.emit()

# Function to remove an item from inventory
func remove_item(item_name: String, amount: int = 1) -> bool:
	if player_inventory.has(item_name) and player_inventory[item_name].amount >= amount:
		player_inventory[item_name].amount -= amount
		inventory_updated.emit()
		return true # Removal was successful
	return false # Not enough items
