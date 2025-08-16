extends CharacterBody2D
var player_nearby := false
var prompt_ui: Control = null
@export var shop_menu: Control
@onready var coins_ui_list = get_tree().get_nodes_in_group("world_coin_ui")
@onready var sfx_open_menu: AudioStreamPlayer = $sfx_open_menu
@onready var sfx_close_menu: AudioStreamPlayer = $sfx_close_menu


func _ready() -> void:
	#var coins_ui_list = get_tree().get_nodes_in_group("world_coin_ui")
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player": # or `body.is_in_group("player")`
		player_nearby = true
		# Get the prompt node inside the player
		prompt_ui = body.get_node("FButton") # replace with your actual node name
		prompt_ui.visible = true
		
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = false
		prompt_ui = body.get_node("FButton") # replace with your actual node name
		prompt_ui.visible = false

func _process(delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		if shop_menu.visible:
			sfx_close_menu.play()
		else:
			sfx_open_menu.play()
		shop_menu.visible = not shop_menu.visible
		prompt_ui.visible = not prompt_ui.visible
		if coins_ui_list.size() > 0:
			coins_ui_list[0].visible = not shop_menu.visible
