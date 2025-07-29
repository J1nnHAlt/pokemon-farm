class_name TransformArea
extends Area2D 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	print("Something entered")
	if is_player(body):
		print("Playerx entered")
		var parent = get_parent()
		_transform(parent)

func _on_body_exited(body: Node) -> void:
	print("Something exited")
	if is_player(body):
		print("Playerx exited")
		var parent = get_parent()
		_untransform(parent)

func _transform(_node: Node) -> void:
	pass

func _untransform(_node: Node) -> void:
	pass
	
	
func is_player(node: Node) -> bool:
	# Basic check — adjust to your player node’s name or type
	return node.is_in_group("player") or node.name == "Player"
