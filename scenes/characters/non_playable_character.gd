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

# Creates a new instance of Godot’s RandomNumberGenerator to generate reproducible or random values
var rng := RandomNumberGenerator.new()

func _ready() -> void:
#	seeds the RNG with a unique value based on the system clock, ensuring different results every run.
	rng.randomize()
#	is set to a random integer between min_walk_cycle and max_walk_cycle, determining how long the NPC will walk.
	walk_cycles = rng.randi_range(min_walk_cycle, max_walk_cycle)
