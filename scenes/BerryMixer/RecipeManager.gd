extends Node

var recipes = {
	"SpicyJam": {
		"ingredients": ["CheriBerry", "PamtreBerry"],
		"texture": preload("res://pokemon-assets/Graphics/Items/CALCIUM.png"), 
		"description": "Really Spicy!"
	},
	"SweetJuice": {
		"ingredients": ["DurinBerry", "CheriBerry"],
		"texture": preload("res://pokemon-assets/Graphics/Items/LEMONADE.png"), 
		"description": "Really Sweet!"
	}
}

func find_matching_recipe(ingredients: Array) -> String:
	var sorted_input = ingredients.duplicate()
	sorted_input.sort()
	
	for recipe_name in recipes:
		var recipe_data = recipes[recipe_name]
		var sorted_recipe = recipe_data["ingredients"].duplicate()
		sorted_recipe.sort()

		if sorted_input == sorted_recipe:
			InventoryManager.add_item(recipe_name, 1)
			return recipe_name
	
	return ""
