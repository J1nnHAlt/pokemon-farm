extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PetSpawnerInFarm.set_pokemon_region("Gyarados", self)
	$"../..".breed_reset.connect(spawn_gyarados)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_gyarados():
	for i in range(GameData.pet_gyarados_amt):
		PetSpawnerInFarm.spawn_pokemon("Gyarados")
