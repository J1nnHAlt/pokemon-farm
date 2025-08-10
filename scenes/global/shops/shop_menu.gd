extends CanvasLayer

@export var possible_items: Array[InvItem] = []
@onready var shop_inv: ShopInv = preload("res://scripts/global/shop_inventory/shop_inv.tres")
@onready var items_container: VBoxContainer = $Control/ShopItems/PanelContainer/MarginContainer/VBoxContainer # Or whatever container your buttons go in
var shop_item_button_scene = preload("res://scenes/global/shops/shop_item_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#visible = false
	_refresh_ui()
	# Optional: auto-update when shop inventory changes
	shop_inv.update.connect(_refresh_ui)
	pass # Replace with function body.

func _refresh_ui():
	# Clear old buttons
	for child in items_container.get_children():
		child.queue_free()

	# Create a button for each shop slot
	for slot in shop_inv.slots:
		var btn = shop_item_button_scene.instantiate()
		btn.set_slot(slot) # You’ll make this in ShopItemButton.gd
		items_container.add_child(btn)


func restock_shop():
	shop_inv.slots.clear() # Empty the shop
	for i in range(3): # Give the shop 3 random items
		var random_item = possible_items.pick_random()
		var random_price = randf_range(10, 100)
		var random_amount = randi_range(1, 5)
		shop_inv.add_item(random_item, random_price, random_amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	restock_shop()
	_refresh_ui()
