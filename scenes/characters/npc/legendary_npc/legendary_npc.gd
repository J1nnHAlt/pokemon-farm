extends Node2D
class_name BerrySellerNpc

@export var dialog_manager: NodePath
@export var berries_required: int = 10  # how many berries needed per sale

var player: Node2D = null
var player_nearby := false
var is_talking := false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_area_body_entered)
		$Area2D.body_exited.connect(_on_area_body_exited)

	var dm = get_node(dialog_manager)
	if dm:
		dm.dialog_done.connect(_on_dialog_done)


func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		player = body
		body.set_interaction_source(self, true)


func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		player = null
		is_talking = false
		var dm = get_node(dialog_manager)
		if dm:
			dm.hide()
		body.set_interaction_source(self, false)


func start_dialog():
	if is_talking or not player_nearby:
		return
	is_talking = true

	var dm = get_node(dialog_manager)
	if not dm:
		return

	dm.start_dialog([
		"Would you like to sell %d berries?" % berries_required,
		"(Any type of berry will do.)"
	])
	dm.show_yes_no()


func _on_dialog_done():
	is_talking = false


func _on_choice_made_yes():
	# Check if player has enough berries in GameData.inventory
	var inv: Inv = GameData.inventory
	if not inv:
		return

	var berries_to_remove := berries_required
	for berry in GameData.berries:
		while berries_to_remove > 0 and inv.has_item(berry):
			inv.remove_item(berry, 1)
			berries_to_remove -= 1
		if berries_to_remove == 0:
			break

	var dm = get_node(dialog_manager)
	if berries_to_remove == 0:
		GameData.total_berries_sold += berries_required
		dm.start_dialog(["You sold %d berries!" % berries_required])
		# Notify LegendarySystem
		var legendary_system = get_tree().get_first_node_in_group("legendary_system")
		if legendary_system:
			legendary_system.on_berry_sold()
	else:
		dm.start_dialog(["You don’t have enough berries."])


func _on_choice_made_no():
	var dm = get_node(dialog_manager)
	if dm:
		dm.start_dialog(["Maybe next time."])
