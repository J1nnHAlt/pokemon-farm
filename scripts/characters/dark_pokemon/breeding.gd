extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D

var _prev_avoidance: bool = true

func _on_enter() -> void:
	# stop physics and agent movement
	character.velocity = Vector2.ZERO
	navigation_agent_2d.velocity = Vector2.ZERO
	# prevent the agent from trying to re-target or use avoidance during breeding
	_prev_avoidance = navigation_agent_2d.avoidance_enabled
	navigation_agent_2d.avoidance_enabled = false
	# keep the target at the current spot so agent thinks it's already there
	navigation_agent_2d.target_position = character.global_position
	# play some idle/mating anim (set the animation in the scene)
	if animated_sprite_2d:
		animated_sprite_2d.play("idle") # or "mating_idle"

func _on_physics_process(_delta: float) -> void:
	# nothing (we've frozen movement)
	pass

func _on_exit() -> void:
	# restore agent settings
	navigation_agent_2d.avoidance_enabled = _prev_avoidance
