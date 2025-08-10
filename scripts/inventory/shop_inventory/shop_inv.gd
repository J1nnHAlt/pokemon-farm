extends Resource
class_name ShopInv

signal update

@export var slots: Array[ShopSlot] = []

func add_item(item: InvItem, price: float, amount: int = 1):
	# Find if the item already exists
	for slot in slots:
		if slot.item == item:
			slot.amount += amount
			update.emit()
			return

	# Otherwise, create a new slot
	var new_slot := ShopSlot.new()
	new_slot.item = item
	new_slot.amount = amount
	new_slot.price = price
	slots.append(new_slot)
	update.emit()

func remove_item(item: InvItem, amount: int = 1):
	for slot in slots:
		if slot.item == item:
			slot.amount -= amount
			if slot.amount <= 0:
				slots.erase(slot)
			update.emit()
			return
