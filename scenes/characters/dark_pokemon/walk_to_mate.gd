extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
var speed: float = 8.0  # fixed speed for mating walk

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)

func _on_enter() -> void:
	animated_sprite_2d.play("walk")

func _on_physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		# Notify BreedingManager they reached the meeting point
		character.emit_signal("reached_mating_point", character)
		print("@breed: reach signal emitted")
		transition.emit("idle")
		return

	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var direction: Vector2 = character.global_position.direction_to(target_position)
	animated_sprite_2d.flip_h = direction.x < 0
	
	var velocity: Vector2 = direction * speed
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	character.move_and_slide()
