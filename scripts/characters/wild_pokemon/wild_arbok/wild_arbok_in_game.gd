extends CharacterBody2D

@export var arbok_base: Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
var targetPosition: Vector2
var borderDistance := 20

func _ready() -> void:
	_set_target_position()
	
func _set_target_position():
#	“time until the size of box has been calculated”
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	_set_new_target_position()

func _set_new_target_position():
	var boxSize := arbok_base.get_global_rect()
	print("Box size: ", boxSize)  # Debug print
	print("Box position: ", boxSize.position)  # Debug print
	print("Box dimensions: ", boxSize.size)  # Debug print

	var xPosition := randi_range(
		boxSize.position.x + borderDistance, boxSize.position.x + boxSize.size.x - borderDistance
	)
	var yPosition := randi_range(
		boxSize.position.y + borderDistance, boxSize.position.y + boxSize.size.y - borderDistance
	)
	targetPosition = Vector2(xPosition, yPosition)
	# Check if target is reachable
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, targetPosition)
	var result = space_state.intersect_ray(query)
	if result:
		print("WARNING: Path to target may be blocked by: ", result.collider)
	
	
var physics_counter = 0  # Add this at the top of your script
func _physics_process(delta: float) -> void:
	physics_counter += 1
	var direction := (targetPosition - global_position).normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var distance = global_position.distance_to(targetPosition)
	if physics_counter % 60 == 0:  # Print every second (assuming 60 FPS)
		print("=== STATUS UPDATE ===")
		print("Counter: ", physics_counter)
		print("Current position: ", global_position)
		print("Target position: ", targetPosition)
		print("Distance to target: ", distance)
		print("Direction: ", direction)
		print("Velocity: ", velocity)
		print("Is moving: ", velocity.length() > 0)
		print("===================")
	
	
	if distance < 5: 
		print("Target reached! Distance: ", distance)
		_on_target()
	
	
	var old_position = global_position
	move_and_slide()
	var movement = global_position - old_position
		# Debug when movement is blocked
	if velocity.length() > 0 and movement.length() < 1.0:  # Should be moving but isn't
		print("MOVEMENT BLOCKED!")
		print("Intended velocity: ", velocity)
		print("Actual movement: ", movement)
		print("Position: ", global_position)
		print("Collision count: ", get_slide_collision_count())
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			print("Colliding with: ", collision.get_collider())
	
	#if distance < 5: 
		#print("Target reached! Distance: ", distance)
		#_on_target()
	_set_animation()

func _on_target():
	print("xx=== ON TARGET CALLED ===")
	print("xxDisabling physics process...")
	set_physics_process(false)
	
	print("xxStarting 1.5 second timer...")
	await get_tree().create_timer(1.5).timeout
	print("xxTimer finished!")
	
	print("xxSetting new target position...")
	_set_new_target_position()
	
	print("xxRe-enabling physics process...")
	set_physics_process(true)
	print("xxPhysics process enabled: ", is_physics_processing())
	print("xx=== ON TARGET COMPLETE ===")


func _set_animation():
	if velocity: animated_sprite_2d.play("default")
	else: animated_sprite_2d.stop()
