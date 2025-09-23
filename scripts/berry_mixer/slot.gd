extends Control

signal slot_clicked(slot: InvSlot, index: int)

var slot_data: InvSlot
var slot_index: int
@export var is_mixer_slot: bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var amount_label: Label = $Label

func _ready() -> void:
	GameData.inventory.update.connect(update_display)

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
		print("clicked button")
		if slot_data and slot_data.item:
			slot_clicked.emit(slot_data, slot_index)
			print("click signal emitted")
			accept_event()
			update_display()

func add_amount(amount_to_add: int):
	if slot_data and slot_data.item:
		slot_data.amount += amount_to_add
		update_display()

func set_is_mixer_slot(value: bool):
	is_mixer_slot = value
