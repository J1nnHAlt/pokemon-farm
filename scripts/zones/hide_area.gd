extends TransformArea
@onready var sfx_enter: AudioStreamPlayer = $"../../sfx_enter"
@onready var sfx_exit: AudioStreamPlayer = $"../../sfx_exit"


func _transform(_node: Node) -> void:
	sfx_enter.play()
	_node.hide()

func _untransform(_node: Node) -> void:
	sfx_exit.play()
	_node.show()
