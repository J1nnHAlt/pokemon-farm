extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

@export var normal_speed: float = 1.0
@export var fast_speed: float = 5.0
@export var cheetah_speed: float = 20.0

func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)
	
	
func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]
	
func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed

func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed

func _on_cheetah_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheetah_speed
