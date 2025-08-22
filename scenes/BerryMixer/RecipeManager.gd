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
		"ingredients": [preload("res://scripts/inventory/items/berries/cheri_berry.tres"), preload("res://scripts/inventory/items/berries/custa_berry.tres")],
		"item": preload("res://scripts/inventory/items/food/spicy_jam.tres"),
		"description": "Really Spicy!"
	},
	"SweetJuice": {
		"ingredients": [preload("res://scripts/inventory/items/berries/durin_berry.tres"), preload("res://scripts/inventory/items/berries/cheri_berry.tres")],
		"item": preload("res://scripts/inventory/items/food/sweet_juice.tres"),
		"description": "Really Sweet!"
	},
	"LeafBites": {
		"ingredients": [preload("res://scripts/inventory/items/berries/durin_berry.tres"), preload("res://scripts/inventory/items/berries/pamtre_berry.tres")],
		"item": preload("res://scripts/inventory/items/food/leaf_bites.tres"),
		"description": "Really Smelly!"
	}, 
	"AquaEssence": {
		"ingredients": [preload("res://scripts/inventory/items/berries/yache_berry.tres"), preload("res://scripts/inventory/items/berries/yache_berry.tres")],
		"item": preload("res://scripts/inventory/items/food/aqua_essence.tres"),
		"description": "Really Moist!"
	}, 
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

#enum PetStatus { Normal, Super_Growth, Mating, Pregnant }
#func check_food_effect(pet_food: String, pokemon_rarity: String, pokemon_element):
	#var status: PetStatus
	#var days_of_effect: int
	#
	#
	#return {
		#"status": status, 
		#"days_of_effect": days_of_effect
		#}
