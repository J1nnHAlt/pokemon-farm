extends NonPlayableCharacter

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	rarity = "Epic"
	element = "Dark"
	for child in $Node2D/Status.get_children():
		print("child: ", child)
		child.visible = false
	$Node2D/InventoryPanel.visible = false
	super._ready()
	_on_attributes_changed()
	
	self.connect("attributes_changed", Callable(self, "_on_attributes_changed"))

@onready var evo_label = $Node2D/Evo
@onready var lvl_label = $Node2D/Lvl
@onready var exp_label = $Node2D/Exp

func _on_attributes_changed():
	evo_label.text = "Evo %d" % evolution
	lvl_label.text = "Lvl %d" % level
	exp_label.text = "Exp %d/%d" % [exp, exp_to_next_level()]	
	for i in status:
		var status_name = PetStatus.keys()[i]
		$Node2D/Status.get_node(status_name).visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Node2D/InventoryPanel.visible = true
