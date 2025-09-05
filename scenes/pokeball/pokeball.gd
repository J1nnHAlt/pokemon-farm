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
	var prob = 0.6
	if body.is_in_group("wild_pokemon") or body.is_in_group("legendary_pokemon"):
		velocity = Vector2.ZERO
		target_pokemon = body
		if prob > 0.5: # success
			play_mini_game()
			#animated_sprite_2d.play("hit")
			#sfx_hit.play()
			#play_captured_sfx()
			#Coin.add_coins(1)
		else: # failed
			play_failed_sfx()
			var fled_label = get_parent().get_node("fled_label")
			get_parent().get_node("flee_particle").global_position = target_pokemon.global_position
			get_parent().get_node("flee_particle").restart()
			fled_label.visible = true
			fled_label.modulate.a = 1.0
			fled_label.global_position = target_pokemon.global_position + Vector2(0, -20) 
			# Tween: move up 30 pixels while fading out over 1 second
			var tween = get_parent().create_tween()
			tween.tween_property(fled_label, "position:y", fled_label.position.y - 30, 1.0)
			tween.parallel().tween_property(fled_label, "modulate:a", 0, 1.0)
			target_pokemon.queue_free()
			queue_free()
		
	else:
#		for hitting environment
		queue_free()


#func _on_animated_sprite_2d_animation_finished() -> void:
	#if animated_sprite_2d.animation == "hit" and target_pokemon and is_instance_valid(target_pokemon):
		#match target_pokemon.name:
			#"WildArbok":
				#GameData.pet_arbok_amt += 1
			#"WildVictreebel":
				#GameData.pet_victreebel_amt += 1
			#"WildLapras":
				#GameData.pet_lapras_amt += 1
			#"LegendaryLugia":
				#GameData.pet_lugia_amt += 1
			#_:
				#print("Unknown Pokémon:", target_pokemon.name)
		#
		#target_pokemon.queue_free()
		#queue_free()

func play_captured_sfx():
	var sound = AudioStreamPlayer.new()
	sound.stream = preload("res://pokemon-assets/Audio/ME/Voltorb Flip win.ogg")
	sound.autoplay = true
	get_tree().current_scene.add_child(sound)  # attach to scene, not this node
	sound.connect("finished", sound.queue_free)
	
func play_failed_sfx():
	var sound = AudioStreamPlayer.new()
	sound.stream = preload("res://pokemon-assets/Audio/SE/Fly.ogg")
	sound.autoplay = true
	get_tree().current_scene.add_child(sound)  # attach to scene, not this node
	sound.connect("finished", sound.queue_free) 

func play_mini_game():
	get_tree().paused = true
	PhysicsServer2D.set_active(true) # make the area2D work during pause
	var catching_game = preload("res://scenes/levels/dungeon_level/catching_game/catching_game.tscn").instantiate()
	get_tree().current_scene.add_child(catching_game)
	
