extends Control

@onready var icon = $Icon

func set_texture(texture: Texture):
	$TextureRect.texture = texture
