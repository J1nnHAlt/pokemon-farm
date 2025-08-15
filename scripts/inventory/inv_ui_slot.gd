extends Panel


#@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var item_visual: TextureRect = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

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
		amount_text.text = str(slot.amount)
		


func _gui_input(event):
	print("Event")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		GameData.inventory.remove(slot_index) # or decrease amount
		GameData.save_game()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
