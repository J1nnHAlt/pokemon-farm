extends GridContainer

var mixer_content: Array[InvItem] = []

func _ready() -> void:
	for slot in get_children():
		if slot.has_method("set_is_mixer_slot"):
			slot.set_is_mixer_slot(true)
			slot.slot_clicked.connect(_on_mixer_slot_clicked)

func add_item(item: InvItem):
	for slot in get_children():
		var slot_data: InvSlot = slot.get_data()
		print("slot data: ", slot_data)
		if slot_data and slot_data.item:
			if slot_data.item == item:
				slot.add_amount(1)
				break
		elif !slot_data or !slot_data.item:
			var new_slot = InvSlot.new()
			new_slot.item = item
			new_slot.amount = 1
			slot.set_data(new_slot, -1)
			break
	
	mixer_content.append(item)
	print("Mixer content:", mixer_content)

func _on_mixer_slot_clicked(slot: InvSlot, index: int):
	if slot.item:
		GameData.inventory.insert(slot.item)
		slot.amount -= 1
		if slot.amount <= 0:
			#slot.clear_data()
			#slot = InvSlot.new()
			slot.item = null
			slot.amount = 0
			#slot = null
		#else:
			#slot.set_data(slot, index)
