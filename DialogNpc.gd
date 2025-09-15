class_name DialogNpc
extends Node2D

@export var npc_id: String = ""   # link to DialogDB
@export var dialog_manager: NodePath        # drag global DialogManager here
@export var npc_sprite_frames: SpriteFrames # assign animations in inspector
@export var default_animation: String = "idle_down"

var player: Node2D = null
var dialog_index := 0
var is_talking := false
var player_nearby := false

func _ready() -> void:
	# setup AnimatedSprite2D
	if npc_sprite_frames and has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.sprite_frames = npc_sprite_frames
		$AnimatedSprite2D.play(default_animation)
	
	# connect signals
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_area_body_entered)
		$Area2D.body_exited.connect(_on_area_body_exited)

	# connect to dialog_done
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
		body.set_interaction_source(self, false)
		player = null
		$AnimatedSprite2D.play(default_animation)  # return to default

func start_dialog():
	if is_talking:
		return
	if player_nearby:
		var dm = get_node(dialog_manager)
		if dm and dm.has_method("start_dialog"):
			is_talking = true
			_face_player()  # NPC faces player immediately
			# Explicitly cast the result to Array[String]
			var raw_lines: Array = DialogDB.dialogs.get(npc_id, [])
			var lines: Array[String] = []
			for l in raw_lines:
				if typeof(l) == TYPE_STRING:
					lines.append(l)
			dm.start_dialog(lines)

func _face_player() -> void:
	if not player or not npc_sprite_frames:
		return
	
	var direction = (player.global_position - global_position).normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D.play("idle_right")
		else:
			$AnimatedSprite2D.play("idle_left")
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("idle_down")
		else:
			$AnimatedSprite2D.play("idle_up")


func _on_dialog_done():
	is_talking = false
	# reset so next F press starts from beginning
