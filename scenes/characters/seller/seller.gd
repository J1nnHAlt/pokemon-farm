extends CharacterBody2D
var player_nearby := false

@export var shop_menu: Control
@onready var coins_ui_list = get_tree().get_nodes_in_group("world_coin_ui")
@onready var sfx_open_menu: AudioStreamPlayer = $sfx_open_menu
@onready var sfx_close_menu: AudioStreamPlayer = $sfx_close_menu


func _ready() -> void:
	#var coins_ui_list = get_tree().get_nodes_in_group("world_coin_ui")
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = true
		body.set_interaction_source(self, true)  # Register seller as interaction source
		# Get the prompt node inside the player
		
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = false
		body.set_meta("in_seller_area", false)
		body.set_interaction_source(self, false)  # Register seller as interaction source
		shop_menu.visible = false

func _process(delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		if shop_menu.visible:
			sfx_close_menu.play()
		else:
			sfx_open_menu.play()
		shop_menu.visible = not shop_menu.visible
		if coins_ui_list.size() > 0:
			coins_ui_list[0].visible = not shop_menu.visible
