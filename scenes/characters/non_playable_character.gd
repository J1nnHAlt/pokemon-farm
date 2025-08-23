class_name NonPlayableCharacter
extends CharacterBody2D

# @export meaning: Visible and editable in the Godot editor
# define the range of walking cycles an NPC can have
# The NPC will walk a random number of times between 2 and 6 before stopping or changing behavior 
#(e.g., standing idle, turning, etc.)
@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6

signal attributes_changed

var walk_cycles: int
var current_walk_cycle: int

enum PetStatus { Normal, Super_Growth, Mating, Pregnant, Maxed }

# Pokemon attributes
var evolution: int = 1
var level: int = 1
var exp: int = 0
var rarity:String = "Common"
var growth_rate: float = 1.0
var element:String = "None"
var status: Array[PetStatus] = [PetStatus.Maxed, PetStatus.Super_Growth]


const GROWTH_RATES := {
	"Common": 1.0, 
	"Rare": 1.2, 
	"Epic": 1.5, 
	"Legendary": 2.0
}

# Creates a new instance of Godot’s RandomNumberGenerator to generate reproducible or random values
var rng := RandomNumberGenerator.new()

func _ready() -> void:
#	seeds the RNG with a unique value based on the system clock, ensuring different results every run.
	rng.randomize()
#	is set to a random integer between min_walk_cycle and max_walk_cycle, determining how long the NPC will walk.
	walk_cycles = rng.randi_range(min_walk_cycle, max_walk_cycle)
	growth_rate = GROWTH_RATES.get(rarity, 1.0)
	DayAndNightCycleManager.time_tick_day.connect(Callable(self, "_on_new_day"))

func gain_exp(amount: int):
	exp+=amount*growth_rate
	if level>=10:
		exp = min(exp, exp_to_next_level()-1)
		if exp == exp_to_next_level()-1: 
			status.append(PetStatus.Maxed)
	while exp >= exp_to_next_level() and level<10:
		level_up()
		
func exp_to_next_level():
	return evolution*level*10
	
func level_up():
	exp-=exp_to_next_level()
	level+=1
	attributes_changed.emit()
	print("Level up! Now at level %d (Evolution %d)" % [level, evolution])
		
func evolve() -> void:
	if level == 10:
		status.erase(PetStatus.Maxed)
		evolution += 1
		level = 1  # reset to level 1 of next evolution
		exp = 0
		print("Evolved to Evolution %d!" % evolution)
		attributes_changed.emit()
	else:
		print("Cannot evolve yet. Must reach level 10 first.")

func _on_new_day(day):
	gain_exp(5)

func consume_pet_food(pet_food: PetFood):
	var effect = RecipeManager.check_food_effect(pet_food, rarity, element)
	if effect["status"]!=PetStatus.Normal and effect["days_of_effect"] != 0:
		if effect["status"] == PetStatus.Maxed:
			evolve()
		elif not status.has(effect["status"]):
			status.append(effect["status"])
		else:
			print("Already eaten before, food wasted!")
		attributes_changed.emit()
