class_name NonPlayableCharacter
extends CharacterBody2D

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6

var walk_cycles: int
var current_walk_cycle: int

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	walk_cycles = rng.randi_range(min_walk_cycle, max_walk_cycle)
