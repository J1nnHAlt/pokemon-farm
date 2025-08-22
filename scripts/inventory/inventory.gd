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
		else:
			slots[index].item = null
			slots[index].amount = 0
		update.emit()
