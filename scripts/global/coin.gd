extends Node

@onready var coins: int = 0
@onready var coin_label: Label = $PanelContainer/MarginContainer/HBoxContainer/Label

func add_coins(amount: int):
	coins += amount

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_label.text = str(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
