extends Node


@onready var coin_label: Label = $PanelContainer/MarginContainer/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_to_group("world_coin_ui")
	refresh_balance()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refresh_balance():
	coin_label.text = str(Coin.coins)
