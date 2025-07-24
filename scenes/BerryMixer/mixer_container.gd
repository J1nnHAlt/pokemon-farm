extends GridContainer

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data)==TYPE_DICTIONARY and data.has("id")
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var mixer_slot = preload("res://scenes/BerryMixer/mixer_slot.tscn").instantiate()
	mixer_slot.set_texture(data.icon)
	add_child(mixer_slot)
	print("dropped berry into mixer: ", data)
