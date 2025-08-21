#extends Control
#
## This signal will be used for different actions based on context
## (e.g., add to mixer, or remove from mixer)
#signal slot_clicked(data)
#
## This will hold the item dictionary (e.g., {"name": "CheriBerry", ...})
#var item_data: Dictionary
#
## Set this to true for mixer slots, false for inventory slots
#@export var is_mixer_slot: bool = false
#
#@onready var texture_rect: TextureRect = $TextureRect
#@onready var amount_label: Label = $Label
#
## Set data and update the visuals
#func set_data(data: Dictionary):
	#item_data = data.duplicate() # Use a copy to avoid reference issues
	#update_display()
#
#func get_data() -> Dictionary:
	#return item_data
#
## Clear data and visuals
#func clear_data():
	#item_data.clear()
	#update_display()
#
## Update what the slot looks like
#func update_display():
	#if item_data.is_empty():
		#texture_rect.texture = null
		#amount_label.text = ""
	#else:
		#texture_rect.texture = item_data.get("texture")
		#amount_label.text = str(item_data.get("amount", 1))
#
## --- Input and Drag-and-Drop ---
#
#func _gui_input(event: InputEvent):
	## Handle left-click
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		#if not item_data.is_empty():
			## Emit the signal with its data when clicked
			#slot_clicked.emit(item_data)
			#print("Slot clicked signal emitted with data:", item_data.get("name"))
			#accept_event() # Consume the event so parents don't process it
#
## What data to send when dragging starts
#func _get_drag_data(_at_position: Vector2) -> Variant:
	#if not item_data.is_empty() and not is_mixer_slot:
		#var drag_preview = TextureRect.new()
		#drag_preview.texture = item_data.texture
		#set_drag_preview(drag_preview)
		#
		## We'll remove one item from the main inventory when the drag STARTS
		#InventoryManager.remove_item(item_data.name, 1)
#
		## Drag a copy of the data, but with amount 1
		#var drag_data = item_data.duplicate()
		#drag_data.amount = 1
		#return drag_data
	#return null # Can't drag from an empty slot or a mixer slot
#
#func add_amount(amount_to_add: int):
	#if not item_data.is_empty():
		#item_data.amount += amount_to_add
		## The existing update_display function will now show the new amount
		#update_display()
#
#
#func set_is_mixer_slot(value):
	#self.is_mixer_slot = value
#
#
#func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	#return data is Dictionary and data.has("name")
	#
#@onready var mixer_content = $".."
#func _drop_data(_at_position: Vector2, data: Variant) -> void:
	## The drop logic is the same as the click logic
	#mixer_content.add_item(data)


extends Control

signal slot_clicked(slot: InvSlot, index: int)

var slot_data: InvSlot
var slot_index: int
@export var is_mixer_slot: bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $Label

func set_data(data: InvSlot, index: int):
	slot_data = data
	slot_index = index
	update_display()

func get_data() -> InvSlot:
	return slot_data

func clear_data():
	slot_data = InvSlot.new()
	update_display()

func update_display():
	if !slot_data or !slot_data.item:
		texture_rect.texture = null
		amount_label.text = ""
	else:
		texture_rect.texture = slot_data.item.texture
		amount_label.text = str(slot_data.amount)

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		if slot_data and slot_data.item:
			slot_clicked.emit(slot_data, slot_index)
			accept_event()
			update_display()

func add_amount(amount_to_add: int):
	if slot_data and slot_data.item:
		slot_data.amount += amount_to_add
		update_display()

func set_is_mixer_slot(value: bool):
	is_mixer_slot = value
