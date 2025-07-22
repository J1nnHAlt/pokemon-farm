extends TransformArea


func _transform(_node: Node) -> void:
	_fade(_node)

func _untransform(_node: Node) -> void:
	_unfade(_node)

func _fade(_node) -> void:
	if _can_fade(_node):
		_node.modulate.a = 0.5
	else:
#		by default parent to fade, if parent cannot fade, the children fade
		for child in _node.get_children():
			_fade(child)

func _unfade(_node) -> void:
	if _can_fade(_node):
		_node.modulate.a = 1
	else:
#		by default parent to fade, if parent cannot fade, the children fade
		for child in _node.get_children():
			_unfade(child)

func _can_fade(_node) -> bool:
	return "modulate" in _node
