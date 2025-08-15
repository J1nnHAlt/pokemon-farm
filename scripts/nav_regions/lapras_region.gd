extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PetSpawnerInFarm.set_pokemon_region("Lapras", self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
