#extends Node
#
#var recipes = {
	#"SpicyJam": {
		#"ingredients": ["CheriBerry", "PamtreBerry"],
		#"texture": preload("res://pokemon-assets/Graphics/Items/CALCIUM.png"), 
		#"description": "Really Spicy!"
	#},
	#"SweetJuice": {
		#"ingredients": ["DurinBerry", "CheriBerry"],
		#"texture": preload("res://pokemon-assets/Graphics/Items/LEMONADE.png"), 
		#"description": "Really Sweet!"
	#}
#}
#
#func find_matching_recipe(ingredients: Array) -> String:
	#var sorted_input = ingredients.duplicate()
	#sorted_input.sort()
	#
	#for recipe_name in recipes:
		#var recipe_data = recipes[recipe_name]
		#var sorted_recipe = recipe_data["ingredients"].duplicate()
		#sorted_recipe.sort()
#
		#if sorted_input == sorted_recipe:
			#InventoryManager.add_item(recipe_name, 1)
			#return recipe_name
	#
	#return ""


extends Node

var recipes = {
	"SpicyJam": {
		"ingredients": [preload("res://scripts/inventory/items/cheri_berry.tres"), preload("res://scripts/inventory/items/pamtre_berry.tres")],
		"item": preload("res://scripts/inventory/items/spicy_jam.tres"),
		"description": "Really Spicy!"
	},
	"SweetJuice": {
		"ingredients": [preload("res://scripts/inventory/items/durin_berry.tres"), preload("res://scripts/inventory/items/cheri_berry.tres")],
		"item": preload("res://scripts/inventory/items/sweet_juice.tres"),
		"description": "Really Sweet!"
	}
}

func find_matching_recipe(ingredients: Array[InvItem]) -> String:
	var sorted_input = ingredients.duplicate()
	sorted_input.sort_custom(func(a, b): return a.name < b.name)
	
	for recipe_name in recipes.keys():
		var recipe_data = recipes[recipe_name]
		var sorted_recipe = recipe_data["ingredients"].duplicate()
		sorted_recipe.sort_custom(func(a, b): return a.name < b.name)

		if sorted_input == sorted_recipe:
			GameData.inventory.insert(recipe_data["item"])
			return recipe_name
	
	return ""
