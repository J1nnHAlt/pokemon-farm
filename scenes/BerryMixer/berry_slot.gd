extends Control

var berry_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = berry_data.get("icon")
	print("slot size: ", self.size)

func _get_drag_data(_at_position: Vector2):
	var drag_preview = TextureRect.new()
	drag_preview.texture = berry_data.get("icon")
	set_drag_preview(drag_preview)
	return berry_data

func set_berry_data(data):
	berry_data = data
	$TextureRect.texture = berry_data.get("icon")
