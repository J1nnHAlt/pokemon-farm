extends Panel

@onready var message = $message
@onready var slot_texture = $Slot/TextureRect
@onready var name_label = $name
@onready var close_button = $CloseButton

func _ready():
	close_button.pressed.connect(_on_close_button_pressed)

func set_display(recipe_name: String, msg: String):
	message.text = msg
	if recipe_name != "":
		var item: InvItem = RecipeManager.recipes[recipe_name]["item"]
		slot_texture.texture = item.texture
		name_label.text = item.name
	else:
		slot_texture.texture = preload("res://pokemon-assets/Graphics/Items/000.png")
		name_label.text = "Unknown Recipe"

func _on_close_button_pressed():
	queue_free()
