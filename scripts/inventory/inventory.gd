extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
		else:
#			inventory is full
			return false
	update.emit()
	return true

func remove(index: int):
	if index >= 0 and index < slots.size():
		if slots[index].amount > 0:
			slots[index].amount -= 1
			if slots[index].amount == 0:
				slots[index].item = null
		update.emit()

func search(name: String):
	for i in range(slots.size()):
		if slots[i].item != null and slots[i].item.name == name:
			return i
	return -1 # not found

func checkAmount(name: String):
	for i in range(slots.size()):
		if slots[i].item != null and slots[i].item.name == name:
			return slots[i].amount
	return -1 # not found
