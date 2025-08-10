extends Button

@onready var item_visual: TextureRect = $PanelContainer/VBoxContainer/HBoxContainer1/Item/ItemVisual
@onready var item_name: Label = $PanelContainer/VBoxContainer/HBoxContainer1/Item/ItemName
@onready var item_price: Label = $PanelContainer/VBoxContainer/HBoxContainer1/Gem/price
@onready var item_amount: Label = $PanelContainer/VBoxContainer/Quantity/amount
@onready var shop_inv: ShopInv = preload("res://scripts/inventory/shop_inventory/shop_inv.tres")
var slot
@onready var player = get_tree().get_nodes_in_group("player")[0]

func set_slot(s):
	slot = s
	await ready
	item_visual.texture = slot.item.texture
	item_name.text = slot.item.name
	item_price.text = str(slot.price)
	item_amount.text = str(slot.amount)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var shop_menu = get_parent().get_parent().get_parent().get_parent().get_parent() # climb up as needed
	if Coin.spend_coins(slot.price):
		shop_inv.remove_item(slot.item)
		shop_menu.refresh_balance()
		player.collect(slot.item)
	else:
		var anim_player = shop_menu.get_node("Balance/AnimationPlayer")
		anim_player.play("not_enough")
	print("Coins remaining:", Coin.coins)
	pass # Replace with function body.
