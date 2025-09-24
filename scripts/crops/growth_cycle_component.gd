class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

	var legendary_manager = get_tree().get_first_node_in_group("legendary_manager")
	if legendary_manager:
		legendary_manager.legendary_activated.connect(_on_legendary_activated)
		legendary_manager.legendary_deactivated.connect(_on_legendary_deactivated)

		if legendary_manager.legendary_active:
			_on_legendary_activated()

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		
		growth_states(starting_day, day)
		harvest_state(starting_day, day)

func _on_legendary_activated():
	days_until_harvest = 5
	starting_day = DayAndNightCycleManager.current_day
	print("Legendary buff applied to crop:", get_parent().name)
	
func _on_legendary_deactivated() -> void:
	days_until_harvest = 7
	print("Legendary buff removed from:", get_parent().name)

func growth_states(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 4
	var growth_days_passed = (current_day - starting_day) % num_states
	var state_index = growth_days_passed % num_states + 1
	
	current_growth_state = state_index
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: ", name, "State index: ", state_index)
	
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()
		
		# Remove the crop from GameData immediately on harvest
		if get_parent().has_method("get_tile_pos"):
			var tile_pos = get_parent().get_tile_pos()
			GameData.remove_crop(tile_pos)

		# Remove the node from the scene
		get_parent().queue_free()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
