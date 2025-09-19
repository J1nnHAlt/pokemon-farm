extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PetSpawnerInFarm.set_pokemon_region("Seaking", self)
	spawn_seaking()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_seaking():
	for i in range(GameData.pet_seaking_amt):
		PetSpawnerInFarm.spawn_pokemon("Seaking")
