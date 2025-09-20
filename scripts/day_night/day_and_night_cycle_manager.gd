extends Node

const MINUTES_PER_HOUR: int = 60
const MINUTES_PER_DAY: int = 24 * MINUTES_PER_HOUR
const REAL_SECONDS_PER_GAME_DAY: float = 1800.0 # 30 minutes = 1800 seconds
const BASE_GAME_MINUTES_PER_SECOND: float = MINUTES_PER_DAY / REAL_SECONDS_PER_GAME_DAY

var game_speed: float = 1.0 # 1.0 means 30 minutes per game day

var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

var time: float = 0.0
var current_minute: int = -1
var current_day: int = 0

signal game_time(time: float)
signal time_tick(day: int, hour: int, minute: int)
signal time_tick_day(day: int)
signal day_changed(new_day: int)

func _ready() -> void:
	# Do nothing here — GameData will initialise us
	pass

func init_time(saved_minutes_today: int, saved_day: int) -> void:
	if saved_day > 0 or saved_minutes_today > 0:
		time = (saved_day * MINUTES_PER_DAY) + saved_minutes_today
	else:
		set_initial_time()
	recalculate_time()


	
func _process(delta: float) -> void:
	time += delta * game_speed * BASE_GAME_MINUTES_PER_SECOND
	game_time.emit(time)
	recalculate_time()

func set_initial_time() -> void:
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute
	time = initial_total_minutes

func recalculate_time() -> void:
	var total_minutes: int = int(time)
	var day: int = total_minutes / MINUTES_PER_DAY
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	var hour: int = current_day_minutes / MINUTES_PER_HOUR
	var minute: int = current_day_minutes % MINUTES_PER_HOUR

	if current_minute != total_minutes:
		current_minute = total_minutes
		time_tick.emit(day, hour, minute)

	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
