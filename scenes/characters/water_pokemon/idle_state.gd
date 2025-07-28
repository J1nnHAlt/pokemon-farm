extends NodeState

#These variables are exposed in the Godot Inspector:
#reference to the NPC’s body for movement
@export var character: CharacterBody2D
#the sprite that will play the "idle" animation.
@export var animated_sprite_2d: AnimatedSprite2D
#how long the NPC should idle before transitioning to walking (default 5 seconds).
@export var idle_state_time_interval: float = 5.0

#@onready ensures it's initialized after the scene is ready.
@onready var idle_state_timer: Timer = Timer.new()

#Used to check if the timer has finished and the idle period is over.
var idle_state_timeout: bool = false

func _ready() -> void:
#	Sets the timer’s duration to the idle interval.
	idle_state_timer.wait_time = idle_state_time_interval
#	Connects the timer’s timeout signal to a function (on_idle_state_timeout()).
	idle_state_timer.timeout.connect(on_idle_state_timeout)
#	Add the timer to the scene
	add_child(idle_state_timer)


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass

#called every physics frame by the NodeStateMachine
func _on_next_transitions() -> void:
#	If the timer has completed (idle_state_timeout == true), it emits a transition to the "walk" state.
	if idle_state_timeout:
		transition.emit("walk")

#Called when the state becomes active.
func _on_enter() -> void:
	animated_sprite_2d.play("idle")
	
#	reset the timeout flag, and starts the timer countdown
	idle_state_timeout = false
	idle_state_timer.start()


func _on_exit() -> void:
#	Stops both the animation and the timer.
	animated_sprite_2d.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true
