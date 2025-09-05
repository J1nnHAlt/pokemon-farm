extends Control

@onready var catching_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/CatchingBar
@onready var timer: Timer = $Timer

var on_catch = false
var catch_speed := 1.5
var catching_value := 0.0

func _ready() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	print("Timer: ", timer.time_left)
	if on_catch: catching_value += catch_speed
	else: catching_value -= catch_speed
	
	if catching_value < 0: catching_value = 0
	elif catching_value >= 100: _game_end()
	
	catching_bar.value = catching_value


func _on_target_target_entered() -> void:
	on_catch = true


func _on_target_target_exited() -> void:
	on_catch = false

func _game_end():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "global_position", global_position + Vector2(0,700), 0.5)
	await tween.finished
	get_tree().paused = false
	queue_free()


func _on_timer_timeout() -> void:
	_game_end()
