extends NonPlayableCharacter

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	rarity = "Rare"
	element = "Water"
	super._ready()
