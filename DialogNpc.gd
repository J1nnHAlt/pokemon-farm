class_name DialogNpc
extends Node2D

@export var npc_id: String = "villager_1"   # link to DialogDB
@export var dialog_manager: NodePath        # drag global DialogManager here
@export var npc_sprite_frames: SpriteFrames # assign animations in inspector
@export var default_animation: String = "idle_down"

var dialog_index := 0

func _ready() -> void:
	# setup AnimatedSprite2D
	if npc_sprite_frames and has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.sprite_frames = npc_sprite_frames
		$AnimatedSprite2D.play(default_animation)
	
	# connect signals
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_area_body_entered)
		$Area2D.body_exited.connect(_on_area_body_exited)

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_interaction_source(self, true)

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_interaction_source(self, false)

func start_dialog():
	var text = DialogDb.get_dialog(npc_id, dialog_index)
	if text != "":
		var dm = get_node(dialog_manager)
		if dm and dm.has_method("start_dialog"):
			dm.start_dialog(text)
