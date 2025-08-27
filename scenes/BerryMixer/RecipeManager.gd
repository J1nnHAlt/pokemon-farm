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
	"DarkCandy": {
		"ingredients": [preload("res://scripts/inventory/items/berries/rawst_berry.tres"), preload("res://scripts/inventory/items/berries/yache_berry.tres")],
		"item": preload("res://scripts/inventory/items/food/dark_candy.tres"),
		"description": "Really Dark!"
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

enum PetStatus { Normal, Super_Growth, Mating, Pregnant, Maxed }
const effect = {
	"Growth": PetStatus.Super_Growth, 
	"Breed": PetStatus.Mating, 
	"Evolve": PetStatus.Maxed, 
}
const rarity = ["Common", "Rare", "Epic", "Legendary"]
func check_food_effect(pet_food: PetFood, pokemon_rarity: String, pokemon_element):
	var status: PetStatus = PetStatus.Normal
	var days_of_effect: int = 0
	if pet_food.type == "Growth" and pet_food.element != pokemon_element:
		print("Wrong element")
	else: 
		var food_rarity_index = rarity.find(pet_food.rarity)
		var poke_rarity_index = rarity.find(pokemon_rarity)
		if food_rarity_index>=poke_rarity_index:
			status = effect[pet_food.type]
			days_of_effect += 1 + food_rarity_index-poke_rarity_index
	
	return {
		"status": status, 
		"days_of_effect": days_of_effect
		}
