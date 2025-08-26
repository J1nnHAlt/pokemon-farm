extends Panel


#@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var item_visual: TextureRect = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var sfx_remove_item: AudioStreamPlayer = $sfx_remove_item

var slot_index: int
var slot_data: InvSlot

func update(slot: InvSlot, index: int):
	
	slot_index = index
	slot_data = slot
	
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		else:
			amount_text.visible = false
		amount_text.text = str(slot.amount)
		

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if slot_data and slot_data.item:
			var was_berry := slot_data.item.name.to_lower().contains("berry")

			sfx_remove_item.play()
			Coin.add_coins(1)

			GameData.inventory.remove(slot_index) # decrease amount/remove
			GameData.save_game()

			# Trigger LegendaryManager if it was a berry
			if was_berry:
				print("Berry sold, calling LegendaryManager")
				LegendaryManager.on_berry_sold()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
