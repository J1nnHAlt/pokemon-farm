extends VBoxContainer

const CARD_SCENE = preload("res://scenes/BerryMixer/RecipeCard.tscn") 
var inventory: Inv

func _ready() -> void:
	update_display()

func update_display():
	# Clear existing slots
	for child in get_children():
		child.queue_free()
		
	for recipe_name in RecipeManager.recipes.keys():
		var recipe = RecipeManager.recipes[recipe_name]
		var card = CARD_SCENE.instantiate()

		# --- Access subnodes ---
		var panel = card.get_node("Panel")
		var item_tex_rect: TextureRect = panel.get_node("TextureRect")
		var item_name_label: Label = panel.get_node("Name") # assumes the Label is named "ItemName"
		var item_desc_label: Label = panel.get_node("Description") # assumes the Label is named "ItemDescription"
		
		var vbox: VBoxContainer = panel.get_node("VBoxContainer")
		var type_label: Label = vbox.get_node("TypeLabel")
		var element_label: Label = vbox.get_node("ElementLabel")
		var rarity_label: Label = vbox.get_node("RarityLabel")
		
		var grid: GridContainer = panel.get_node("GridContainer")

		# --- Update with recipe item info ---
		var item: PetFood = recipe["item"]  # recipe["item"] is a PetFood resource
		
		item_tex_rect.texture = item.texture
		item_name_label.text = item.name
		item_desc_label.text = recipe["description"]

		type_label.text = "Type: %s" % item.type
		element_label.text = "Element: %s" % item.element
		rarity_label.text = "Rarity: %s" % item.rarity

		# --- Add ingredient textures dynamically ---
		for ingredient in recipe["ingredients"]:
			var tex_rect = TextureRect.new()
			tex_rect.texture = ingredient.texture
			tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			grid.add_child(tex_rect)

		# Finally add the card to the VBoxContainer
		add_child(card)
