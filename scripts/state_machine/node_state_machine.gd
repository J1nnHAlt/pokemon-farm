class_name NodeStateMachine
extends Node
#This script defines a finite state machine (FSM) system in Godot, where each child node is a state

#Allows you to set the initial state from the inspector.
@export var initial_node_state : NodeState

#A dictionary to map state names (as lowercase strings) to actual state node instances.
var node_states : Dictionary = {}
#Holds a reference to the currently active state.
var current_node_state : NodeState
#Stores the name of the current state as a string (in lowercase)
var current_node_state_name : String
#Stores the name of the parent node
var parent_node_name: String

func _ready() -> void:
#	Stores the name of this node’s parent in parent_node_name
	parent_node_name = get_parent().name
	
#	Loops through all child nodes of this state machine node.
	for child in get_children():
#		Checks if the child is of type NodeState
		if child is NodeState:
#			Adds the child to the node_states dictionary using its lowercase name as the key.
			node_states[child.name.to_lower()] = child
#			Connects the state’s transition signal to the transition_to() function, enabling the state to request a transition.
			child.transition.connect(transition_to)
#	If the initial state is set:
	if initial_node_state:
#		Call the state's _on_enter() method to handle entry logic (e.g., animation, reset values).
		initial_node_state._on_enter()
#		Set the current state and its name.
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()

#Per-frame Logic
func _process(delta : float) -> void:
#	If a current state is active, forward the _process(delta) call to it.
	if current_node_state:
		current_node_state._on_process(delta)

#Per-physics-frame Logic
func _physics_process(delta: float) -> void:
#	Only run if a state is active.
	if current_node_state:
#		Calls the state’s physics update method (e.g., for movement or physics calculations).
		current_node_state._on_physics_process(delta)
#		Lets the state evaluate whether it should transition to another state.
		current_node_state._on_next_transitions()
#		Debug print: shows which state the parent node (NPC/character/etc.) is currently in.
		print(parent_node_name, " Current state: ", current_node_state_name)

#Called when a state wants to transition to another state.
func transition_to(node_state_name : String) -> void:
#	Prevents transitioning to the same state.
	if node_state_name == current_node_state.name.to_lower():
		return
	
#	Gets the new state object from the dictionary.
	var new_node_state = node_states.get(node_state_name.to_lower())
	
#	If the requested state doesn't exist, exit the function (fail-safe).
	if !new_node_state:
		return
	
	if current_node_state:
#		Call the exit method of the current state.
		current_node_state._on_exit()
#	Enter the new state.
	new_node_state._on_enter()
	
#	Update the state references.
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()
	print("Current State: ", current_node_state_name)
