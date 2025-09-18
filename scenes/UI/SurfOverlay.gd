extends Control

signal overlay_done

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func play_overlay():
	visible = true
	anim.play("summon")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "summon":
		visible = false   # hide after done
		emit_signal("overlay_done")
