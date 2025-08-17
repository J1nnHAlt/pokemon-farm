# Pokeball.gd (attached to your Pokeball scene)
extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_hit: AudioStreamPlayer = $sfx_hit

@export var speed: float = 400.0
var velocity: Vector2
var target_pokemon: CharacterBody2D

func _physics_process(delta):
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wild_pokemon"):
#		make it not everytime success
		animated_sprite_2d.play("hit")
		sfx_hit.play()
		Coin.add_coins(1)
		velocity = Vector2.ZERO
		target_pokemon = body
	else:
#		for hitting environment
		queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "hit" and target_pokemon and is_instance_valid(target_pokemon):
		match target_pokemon.name:
			"WildArbok":
				GameData.pet_arbok_amt += 1
			"WildVictreebel":
				GameData.pet_victreebel_amt += 1
			"WildLapras":
				GameData.pet_lapras_amt += 1
			_:
				print("Unknown Pokémon:", target_pokemon.name)
		
		target_pokemon.queue_free()
		queue_free()
