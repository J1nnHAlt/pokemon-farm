class_name NonPlayableCharacter
extends CharacterBody2D

# @export meaning: Visible and editable in the Godot editor
# define the range of walking cycles an NPC can have
# The NPC will walk a random number of times between 2 and 6 before stopping or changing behavior 
#(e.g., standing idle, turning, etc.)
@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6

var walk_cycles: int
var current_walk_cycle: int

# Pokemon attributes
var evolution: int = 1
var level: int = 1
var exp: int = 0
var rarity:String = "Common"
var growth_rate: float = 1.0

const GROWTH_RATES := {
	"Common": 1.0, 
	"Rare": 1.2, 
	"Epic": 1.5, 
	"Legendary": 2.0
}

# Creates a new instance of Godot’s RandomNumberGenerator to generate reproducible or random values
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	print("npc ready")
#	seeds the RNG with a unique value based on the system clock, ensuring different results every run.
	rng.randomize()
#	is set to a random integer between min_walk_cycle and max_walk_cycle, determining how long the NPC will walk.
	walk_cycles = rng.randi_range(min_walk_cycle, max_walk_cycle)
	growth_rate = GROWTH_RATES.get(rarity, 1.0)
	print("npc ready")
	DayAndNightCycleManager.time_tick_day.connect(Callable(self, "_on_new_day"))
	print("Signal connected")

func gain_exp(amount: int):
	if level>=10:
		exp = min(exp, exp_to_next_level()-1)
		return
	exp+=amount*growth_rate
	while exp >= exp_to_next_level() and level<10:
		level_up()
		
func exp_to_next_level():
	return evolution*level*10
	
func level_up():
	if level<10:
		level+=1
		exp = 0
		print("Level up! Now at level %d (Evolution %d)" % [level, evolution])
		
	elif level == 10:
		print("Max level reached for Evolution %d. Needs pet food to evolve!" % evolution)
		
func evolve() -> void:
	if level == 10:
		evolution += 1
		level = 1  # reset to level 1 of next evolution
		exp = 0
		print("Evolved to Evolution %d!" % evolution)
	else:
		print("Cannot evolve yet. Must reach level 10 first.")

func _on_new_day(day):
	print("new day, get exp")
	gain_exp(5)
