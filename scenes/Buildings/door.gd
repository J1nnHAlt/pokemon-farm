extends Area2D
class_name Door

@export_file("*.tscn") var target_scene: String   # Scene this door leads to (interior)
@export var target_spawn: String = ""

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var is_opening := false

func open_door():
	if not is_opening:
		is_opening = true
		visible = true  # make sure door is visible
		anim.play("open_door")
		await anim.animation_finished
		is_opening = false   # reset so door can be opened again
		visible = false

func close_door():
	visible = true  # always visible while closing
	anim.play("close_door")
	await anim.animation_finished
	visible = true  # keep visible after closed
