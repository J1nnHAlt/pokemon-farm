extends Node

var pokemon_scenes := {
	"Arbok": preload("res://scenes/characters/dark_pokemon/arbok.tscn"),
	#"Victreebel": preload("res://scenes/characters/grass_pokemon/victreebel.tscn"),
	"Lapras": preload("res://scenes/characters/water_pokemon/lapras.tscn"),
	"Magikarp": preload("res://scenes/characters/water_pokemon/magikarp.tscn"),
	"Seaking": preload("res://scenes/characters/water_pokemon/seaking.tscn"),
	"Gyarados": preload("res://scenes/characters/water_pokemon/gyarados.tscn"),
	"Kyogre": preload("res://scenes/characters/water_pokemon/kyogre.tscn"),
}

var pokemon_regions := {} # Dictionary to store regions per type

func set_pokemon_region(pokemon_type: String, region: NavigationRegion2D):
	pokemon_regions[pokemon_type] = region

func spawn_pokemon(pokemon_type: String):
	if pokemon_type not in pokemon_scenes:
		push_warning("No scene found for: " + pokemon_type)
		return
	if pokemon_type not in pokemon_regions:
		push_warning("No region found for: " + pokemon_type)
		return
	
	var nav_region = pokemon_regions[pokemon_type]
	var npc_scene = pokemon_scenes[pokemon_type]
	var npc = npc_scene.instantiate()
	npc.position = get_random_point_in_region(nav_region)
	nav_region.add_child(npc)
	BreedingManager.register_npc(npc)

func get_random_point_in_region(nav_region: NavigationRegion2D) -> Vector2:
	var polygon: PackedVector2Array = nav_region.navigation_polygon.get_outline(0)
	var rect := Rect2()
	for point in polygon:
		rect = rect.expand(point)
	var random_point: Vector2
	var tries = 0
	while true:
		tries += 1
		random_point = Vector2(
			randf_range(rect.position.x, rect.position.x + rect.size.x),
			randf_range(rect.position.y, rect.position.y + rect.size.y)
		)
		if Geometry2D.is_point_in_polygon(random_point, polygon):
			break
		if tries > 100:
			break
	return random_point


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#		PetSpawnerInFarm.spawn_pokemon("Arbok") call like this for global script
