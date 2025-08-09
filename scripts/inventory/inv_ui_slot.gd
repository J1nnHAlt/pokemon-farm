extends Panel


#@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var item_visual: TextureRect = $CenterContainer/Panel/item_display
func update(item: InvItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
