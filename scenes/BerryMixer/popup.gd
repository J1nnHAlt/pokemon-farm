extends Panel

@onready var message = $message
@onready var slot_texture = $Slot/TextureRect
@onready var name_label = $name
@onready var close_button = $CloseButton

func _ready():
	close_button.pressed.connect(_on_close_button_pressed)

func set_display(recipe_name: String, msg: String):
	print("recipe name and msg", recipe_name, msg)
	message.text = msg
	if recipe_name!="":
		var texture = RecipeManager.recipes[recipe_name].texture
		slot_texture.texture = texture
	else:
		slot_texture.texture = preload("res://pokemon-assets/Graphics/Items/000.png")
	name_label.text = recipe_name

func _on_close_button_pressed():
	queue_free()  # Destroys this popup
