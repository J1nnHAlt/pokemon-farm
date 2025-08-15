extends Node

func add_coins(amount: int):
	GameData.coins += amount
	GameData.emit_signal("coins_loaded")
	GameData.save_game()

func spend_coins(amount: int) -> bool:
	if GameData.coins >= amount:
		GameData.coins -= amount
		GameData.emit_signal("coins_loaded")
		GameData.save_game()
		return true
	return false
