extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

#@export var exit_position: NodePath   # optional teleport target (inside building)

var is_opening := false

func open_door():
	if not is_opening:
		is_opening = true
		anim.play("open_door")

func close_door():
	is_opening = false
	anim.play("close_door")

#func get_exit_position() -> Vector2:
	#if exit_position != NodePath():
		#var node = get_node(exit_position)
		#if node:
			#return node.global_position
	#return global_position  # fallback: teleport to door itself
