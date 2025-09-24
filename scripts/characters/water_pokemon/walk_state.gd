extends NodeState

#your NPC, which contains state info like walk_cycles
@export var character: NonPlayableCharacter
#controls the "walk" animation and flipping.
@export var animated_sprite_2d: AnimatedSprite2D
#the core of pathfinding—finds safe paths using the navigation map.
@export var navigation_agent_2d: NavigationAgent2D
#define a range of random movement speed per walk cycle.
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

#Holds the actual walking speed for this instance
var speed: float

func _ready() -> void:
#	Connects the velocity_computed signal to a method that handles safe movement
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
#	call func after current frame finished processing
#delay the setup until the node is fully ready (important for navmesh).
	call_deferred("character_setup")

func character_setup() -> void:
#	Waits one physics frame (await get_tree().physics_frame) to let the scene finish loading.
	await get_tree().physics_frame
	#	delay to ensure navmesh is baked, else all pokemon NPCs gonna move same direction at start
	await get_tree().create_timer(0.1).timeout
#	Then sets the NPC’s first random movement target.
	set_movement_target()

func set_movement_target() -> void:
#	Uses NavigationServer2D.map_get_random_point() to pick a random point on the navigation mesh.
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(), navigation_agent_2d.navigation_layers, false)
#	Sets it as the NPC’s target destination.
	navigation_agent_2d.target_position = target_position
#	Chooses a random speed in the defined range.
	speed = randf_range(min_speed, max_speed)
	
func _on_process(_delta : float) -> void:
	pass

#Runs every physics frame (called by NodeStateMachine).
func _on_physics_process(_delta : float) -> void:
#	Checks if the NPC has reached its current destination.
	if navigation_agent_2d.is_navigation_finished():
#		Increments the walk cycle count.
		character.current_walk_cycle += 1
#		Picks a new destination.
		set_movement_target()
#		Skips the rest of the frame.
		return
		
#	Gets the next position along the path and calculates the direction.
	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
#	Flips the sprite left/right depending on direction (so the NPC faces the correct way).
	animated_sprite_2d.flip_h = target_direction.x < 0
#	Calculates the velocity vector toward the target.
	var velocity: Vector2 = target_direction * speed
	
#	If avoidance is enabled (for crowd AI), the NavigationAgent2D handles pathing.
	if navigation_agent_2d.avoidance_enabled:
		animated_sprite_2d.flip_h = velocity.x < 0
#		Set the velocity in the agent.
#		The agent internally processes that velocity (during _physics_process) and computes a safe movement vector, considering:
#		-Avoiding other agents (crowd).
#		-Obstacles.
#		-The shortest path to the goal.
#		When the safe velocity is computed, the velocity_computed signal is triggered:
		navigation_agent_2d.velocity = velocity
	else:
#		Otherwise, it moves the character manually using Godot’s physics engine.
		character.velocity = velocity
		character.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()

#called every physics frame by the NodeStateMachine
func _on_next_transitions() -> void:
#	if the walk cycle is not equals, it will continue to walk, but with different direction
	if character.current_walk_cycle == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("idle")


func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0


func _on_exit() -> void:
	animated_sprite_2d.stop()
