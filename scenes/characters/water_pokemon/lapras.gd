extends NonPlayableCharacter

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	rarity = "Rare"
	element = "Water"
	super._ready()
	
@onready var evo_label = $Node2D/Evo
@onready var lvl_label = $Node2D/Lvl
@onready var exp_label = $Node2D/Exp

func _process(delta: float) -> void:
	evo_label.text = "Evo %d" % evolution
	lvl_label.text = "Lvl %d" % level
	exp_label.text = "Exp %d/%d" % [exp, exp_to_next_level()]	
