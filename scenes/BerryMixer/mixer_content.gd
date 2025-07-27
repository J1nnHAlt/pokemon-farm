#extends GridContainer
#
#@export var mixer_content = []
#
#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#return typeof(data)==TYPE_DICTIONARY
	#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#var mixer_slots = get_children()
	#
	#for slot in mixer_slots:
		#if not slot.get_data():
			#slot.set_data(data)
			#mixer_content.append(data.name)
			#print(mixer_content)
			#break
		#elif slot.get_data().name == data.name:
			#slot.add_amount()
			#mixer_content.append(data.name)
			#print(mixer_content)
			#break
		#else:
			#continue


extends GridContainer

var mixer_content = []

func _ready() -> void:
	# Set up all child slots as "mixer slots" and connect their signals
	for slot in get_children():
		if slot.has_method("set_is_mixer_slot"): # A safe check
			slot.set_is_mixer_slot(true)
			slot.slot_clicked.connect(_on_mixer_slot_clicked)
			print("on mixer slot clicked connected")

# --- Public Functions ---

func add_item(data: Dictionary):
	# First, try to stack with an existing item
	for slot in get_children():
		var slot_data = slot.get_data()
		if not slot_data.is_empty() and slot_data.name == data.name:
			slot.add_amount(1)
			print(slot.get_data())
			break
		elif slot_data.is_empty():
			var new_item_data = data.duplicate()
			new_item_data.amount = 1
			slot.set_data(new_item_data)
			print(slot.get_data())
			break
	
	mixer_content.append(data.name)
	print(mixer_content)

# When a mixer slot is clicked, remove the item from it
func _on_mixer_slot_clicked(data: Dictionary):
	print("on mixer slot clicked called")
	for slot in get_children():
		var slot_data = slot.get_data()
		if not slot_data.is_empty() and slot_data.name == data.name:
			# Add the item back to the main inventory
			InventoryManager.add_item(data.name, 1)

			# Decrease amount or clear the slot
			slot_data.amount -= 1
			if slot_data.amount <= 0:
				slot.clear_data()
			else:
				slot.set_data(slot_data)
			return

# --- Drag-and-Drop ---

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("name")
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# The drop logic is the same as the click logic
	add_item(data)
