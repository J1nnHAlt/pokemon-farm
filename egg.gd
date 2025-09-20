extends Node2D
class_name egg

var pokemon: NonPlayableCharacter
var days_to_hatch: int
var current_day: int

const HATCHING_DAYS := {
	#"Common": 3,
	#"Rare": 5,
	#"Epic": 7,
	#"Legendary": 10
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

enum EggState { IDLE, SHAKING, BOUNCING, CRACKING }
var state: EggState = EggState.IDLE

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(_on_new_day)
	print("@egg: connected to time")
	_set_state(EggState.IDLE)
	_update_label()
	
func setup(p_pokemon: NonPlayableCharacter, p_rarity, p_element) -> void:
	pokemon = p_pokemon.duplicate()  # duplicate so egg holds its own copy
	pokemon.rarity = p_rarity
	pokemon.element = p_element
	days_to_hatch = HATCHING_DAYS.get(pokemon.rarity, 3)
	current_day = 0

	
func _on_new_day(day):
	print("@egg: new day called")
	current_day += 1
	print("@egg: day added")
	_update_label()

	if current_day == days_to_hatch - 2:
		# Shake randomly (only once that day)
		if randi() % 2 == 0:
			_play_once(EggState.SHAKING)

	elif current_day == days_to_hatch -1:
		# Bounce randomly before hatching sequence
		if randi() % 2 == 0:
			_play_once(EggState.BOUNCING)

	elif current_day==days_to_hatch:
		_born()
		

func _born():
	await _play_once(EggState.SHAKING)
	await _play_once(EggState.BOUNCING)
	await _play_once(EggState.CRACKING)

	pokemon._reset()
	print("@egg: rarity after born", pokemon.rarity)
	# Add the egg to the same parent
	if get_parent():
		get_parent().add_child(pokemon)
		pokemon.position = position + Vector2(16, 0) # offset a bit so it's not overlapping
	print("egg hatched")
	
	queue_free()

func _update_label():
	label.text = "Days: %d/%d" % [current_day, days_to_hatch]
	print("@egg: label updated")

func _set_state(new_state: EggState):
	state = new_state
	match state:
		EggState.IDLE: sprite.play("idle")
		EggState.SHAKING: sprite.play("shaking")
		EggState.BOUNCING: sprite.play("bouncing")
		EggState.CRACKING: sprite.play("cracking")

# Plays an animation once and waits until it finishes, then returns to idle
func _play_once(new_state: EggState) -> void:
	_set_state(new_state)
	await sprite.animation_finished
	_set_state(EggState.IDLE)
