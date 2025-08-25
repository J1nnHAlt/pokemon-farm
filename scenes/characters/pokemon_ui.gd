extends Control

func _ready() -> void:
	for child in $Status.get_children():
		print("child: ", child)
		child.visible = false
	_on_attributes_changed()
	
	$"..".attributes_changed.connect(_on_attributes_changed)
	#self.connect("attributes_changed", Callable(self, "_on_attributes_changed"))

@onready var evo_label = $Node2D/Evo
@onready var lvl_label = $Node2D/Lvl
@onready var exp_label = $Node2D/Exp

@onready var pokemon = $".."

func _on_attributes_changed():
	evo_label.text = "Evo %d" % pokemon.evolution
	lvl_label.text = "Lvl %d" % pokemon.level
	exp_label.text = "Exp %d/%d" % [pokemon.exp, pokemon.exp_to_next_level()]	
	for i in pokemon.status:
		var status_name = pokemon.PetStatus.keys()[i]
		$Status.get_node(status_name).visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	GameData.player_entered.emit(get_parent())

func _on_area_2d_body_exited(body: Node2D) -> void:
	GameData.player_exited.emit()
