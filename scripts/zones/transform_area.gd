class_name TransformArea
extends Area2D 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if is_player(body):
		var parent = get_parent()
		_transform(parent)

func _on_body_exited(body: Node) -> void:
	if is_player(body):
		var parent = get_parent()
		_untransform(parent)

func _transform(_node: Node) -> void:
	pass

func _untransform(_node: Node) -> void:
	pass
	
	
func is_player(node: Node) -> bool:
	# Basic check — adjust to your player node’s name or type
	return node.name == "Player"
