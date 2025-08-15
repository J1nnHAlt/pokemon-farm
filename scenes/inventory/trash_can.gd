extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#called automatically by Godot when something is dragged over this Control node.		
func _can_drop_data(position, data):
	return data.has("delete") and data["delete"] == true

#Called automatically by Godot when you release the mouse while dragging over this control and _can_drop_data() returned true
func _drop_data(position, data):
	GameData.inventory.remove(data["slot_index"])
	GameData.save_inventory()
	print("Deleted slot ", data["slot_index"])
