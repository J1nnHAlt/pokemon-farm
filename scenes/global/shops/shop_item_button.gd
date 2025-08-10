extends Button

@onready var item_visual: TextureRect = $HBoxContainer/ItemVisual
@onready var item_name: Label = $HBoxContainer/ItemName
@onready var item_price: Label = $HBoxContainer2/price
var slot

func set_slot(s):
	slot = s
	await ready
	item_visual.texture = slot.item.texture
	item_name.text = slot.item.name
	item_price.text = str(slot.price)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
