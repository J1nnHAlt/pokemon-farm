class_name FishingShopNpc
extends Node2D

@export var dialog_manager: NodePath
@export var npc_sprite_frames: SpriteFrames
@export var default_animation: String = "idle_down"

var player: Node2D = null
var is_talking := false
var player_nearby := false
var asking_upgrade := false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Upgrade requirements: rod_level → {pokemon: amount}
var upgrade_requirements := {
	0: {"magikarp": 3},   # upgrade from level 0 → 1
	1: {"seaking": 2},    # upgrade from level 1 → 2
	2: {"gyarados": 1},   # upgrade from level 2 → 3
}

func _ready() -> void:
	if npc_sprite_frames:
		anim_sprite.sprite_frames = npc_sprite_frames
		anim_sprite.play(default_animation)

	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_area_body_entered)
		$Area2D.body_exited.connect(_on_area_body_exited)

	var dm = get_node(dialog_manager)
	if dm:
		dm.dialog_done.connect(_on_dialog_done)

		# Correct Godot 4 syntax with Callable
		if not dm.is_connected("yes_selected", Callable(self, "_on_choice_made_yes")):
			dm.connect("yes_selected", Callable(self, "_on_choice_made_yes"))

		if not dm.is_connected("no_selected", Callable(self, "_on_choice_made_no")):
			dm.connect("no_selected", Callable(self, "_on_choice_made_no"))


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
		asking_upgrade = false
		var dm = get_node(dialog_manager)
		if dm:
			dm.hide()
			dm.hide_yes_no()
		body.set_interaction_source(self, false)
		anim_sprite.play(default_animation)

func start_dialog():
	if is_talking or not player_nearby:
		return
	
	is_talking = true
	_face_player()

	var dm = get_node(dialog_manager)
	if not dm:
		return

	# Check fishing rod level
	if player.fishing_rod_level < 3:
		var reqs = upgrade_requirements.get(player.fishing_rod_level, {})
		var req_text := "To upgrade, you need:\n"
		for name in reqs.keys():
			req_text += "- %d %s\n" % [reqs[name], name]

		dm.start_dialog([
			"Your fishing rod is level %d." % player.fishing_rod_level,
			req_text,
			"Do you want to upgrade it?"
		])
		asking_upgrade = true
	else:
		dm.start_dialog(["Your fishing rod is already max level (3)."])
		asking_upgrade = false


func _face_player() -> void:
	if not player or not npc_sprite_frames:
		return
	
	var direction = (player.global_position - global_position).normalized()
	if abs(direction.x) > abs(direction.y):
		anim_sprite.play("idle_right" if direction.x > 0 else "idle_left")
	else:
		anim_sprite.play("idle_down" if direction.y > 0 else "idle_up")

func _on_dialog_done():
	if asking_upgrade:
		var dm = get_node(dialog_manager)
		if dm:
			dm.show()
			dm.show_yes_no()
			print("@Dialog: call show_yes_no from fishing npc")
	else:
		is_talking = false

func _on_choice_made_yes():
	var current_level = player.fishing_rod_level
	var reqs = upgrade_requirements.get(current_level, {})

	# Check GameData against requirements
	var has_all := true
	for name in reqs.keys():
		var count = GameData.get("pet_%s_amt" % name.to_lower())
		if count < reqs[name]:
			has_all = false
			break

	var dm = get_node(dialog_manager)
	if not dm:
		return

	if has_all:
		# Deduct Pokémon
		for name in reqs.keys():
			var key = "pet_%s_amt" % name.to_lower()
			GameData.set(key, GameData.get(key) - reqs[name])

		# Upgrade rod
		player.upgrade_fishing_rod()
		dm.start_dialog(["Your fishing rod has been upgraded to level %d!" % player.fishing_rod_level])
	else:
		var missing_text := "You don’t have enough Pokémon.\nYou need:\n"
		for name in reqs.keys():
			var count = GameData.get("pet_%s_amt" % name.to_lower())
			missing_text += "- %d %s (you have %d)\n" % [reqs[name], name, count]
		dm.start_dialog([missing_text])

	asking_upgrade = false


func _on_choice_made_no():
	var dm = get_node(dialog_manager)
	if dm:
		dm.start_dialog(["Maybe next time."])
	asking_upgrade = false
