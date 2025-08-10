extends Button

@onready var item_visual: TextureRect = $PanelContainer/VBoxContainer/HBoxContainer1/Item/ItemVisual
@onready var item_name: Label = $PanelContainer/VBoxContainer/HBoxContainer1/Item/ItemName
@onready var item_price: Label = $PanelContainer/VBoxContainer/HBoxContainer1/Gem/price
@onready var item_amount: Label = $PanelContainer/VBoxContainer/Quantity/amount
var slot

func set_slot(s):
	slot = s
	await ready
	item_visual.texture = slot.item.texture
	item_name.text = slot.item.name
	item_price.text = str(slot.price)
	item_amount.text = str(slot.amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("Buy button is pressed")
	pass # Replace with function body.
