extends TransformArea

func _transform(_node: Node) -> void:
	_node.hide()

func _untransform(_node: Node) -> void:
	_node.show()
