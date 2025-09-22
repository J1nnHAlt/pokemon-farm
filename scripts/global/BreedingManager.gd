extends Node

var npcs: Array = []
var heart_cloud_scene := preload("res://scenes/characters/breed_effect.tscn")


func register_npc(npc: NonPlayableCharacter):
	npcs.append(npc)
	npc.attributes_changed.connect(_on_attributes_changed.bind(npc))

func _on_attributes_changed(npc: NonPlayableCharacter):
	if not npc.status.has(npc.PetStatus.Mating):
		return
	
	for other in npcs:
		if other == npc:
			continue
		if other.status.has(other.PetStatus.Mating):
			move_pokemon_to_meet(npc, other)
			break

func move_pokemon_to_meet(npc1: NonPlayableCharacter, npc2: NonPlayableCharacter) -> void:
	print("@breed: walking to mate")

	# Calculate midpoint between both
	var midpoint = (npc1.global_position + npc2.global_position) / 2.0
	
	# Offset so they don't overlap
	var offset = Vector2(12, 12)

	# Configure NPC1 navigation
	npc1.navigation_agent_2d.target_position = midpoint - offset
	npc1.navigation_agent_2d.target_desired_distance = 5
	npc1.state_machine.transition_to("WalkToMate")

	# Configure NPC2 navigation
	npc2.navigation_agent_2d.target_position = midpoint + offset
	npc2.navigation_agent_2d.target_desired_distance = 5
	npc2.state_machine.transition_to("WalkToMate")

	# Connect both NPCs' signals to BreedingManager (if not already)
	if not npc1.is_connected("reached_mating_point", Callable(self, "_on_reached_meeting_point")):
		npc1.reached_mating_point.connect(_on_reached_meeting_point.bind(npc2))
		print("@breed: connected npc1 to reach signal")

	if not npc2.is_connected("reached_mating_point", Callable(self, "_on_reached_meeting_point")):
		npc2.reached_mating_point.connect(_on_reached_meeting_point.bind(npc1))
		print("@breed: connected npc2 to reach signal")

var meeting_pairs = {}  
func _on_reached_meeting_point(npc: NonPlayableCharacter, other: NonPlayableCharacter):
	print("@breed: reached meeting point", npc.name)
	
	var ids = [npc.get_instance_id(), other.get_instance_id()]
	ids.sort()
	var pair_id = str(ids[0]) + "_" + str(ids[1])

	if not meeting_pairs.has(pair_id):
		meeting_pairs[pair_id] = { "npc1": npc, "npc2": other, "arrived": [] }

	var pair = meeting_pairs[pair_id]
	if not npc in pair["arrived"]:
		pair["arrived"].append(npc)

	if pair["npc1"] in pair["arrived"] and pair["npc2"] in pair["arrived"]:
		print("@breed: both arrived, starting breeding")
		_start_breeding(pair["npc1"], pair["npc2"], pair_id)  # pass pair_id



func _start_breeding(npc1: NonPlayableCharacter, npc2: NonPlayableCharacter, pair_id: String):
	print("@breed: start breeding")
	var effect = heart_cloud_scene.instantiate()
	effect.global_position = ((npc1.global_position + npc2.global_position) / 2.0) + Vector2(-5, -10)
	effect.z_index = 20
	effect.scale = npc1.scale * Vector2(1.5, 2.0)
	npc1.get_parent().add_child(effect)

	# start breeding
	npc1.state_machine.transition_to("Breeding")
	npc2.state_machine.transition_to("Breeding")

	await get_tree().create_timer(5.0).timeout
	
	effect.queue_free()
	_breed(npc1, npc2)

	# after effect finishes
	npc1.state_machine.transition_to("Idle")
	npc2.state_machine.transition_to("Idle")

	# cleanup only after finished
	meeting_pairs.erase(pair_id)

	# disconnect signals to avoid duplicates
	if npc1.is_connected("reached_mating_point", Callable(self, "_on_reached_meeting_point")):
		npc1.disconnect("reached_mating_point", Callable(self, "_on_reached_meeting_point"))
	if npc2.is_connected("reached_mating_point", Callable(self, "_on_reached_meeting_point")):
		npc2.disconnect("reached_mating_point", Callable(self, "_on_reached_meeting_point"))


func _breed(npc1: NonPlayableCharacter, npc2: NonPlayableCharacter):
	# Erase mating status
	npc1.status.erase(npc1.PetStatus.Mating)
	npc2.status.erase(npc2.PetStatus.Mating)

	# Probability of pregnancy depends on rarity
	var chosen = npc1 if randf() < 0.5 else npc2
	var rarity = chosen.rarity
	var rarity_chances := {
	"Common": 0.8,
	"Rare": 0.4,
	"Epic": 0.2,
	"Legendary": 0.1
}

	var chance: float = rarity_chances.get(rarity, 0.5)

	if randf() < chance:
		chosen.status[chosen.PetStatus.Pregnant] = 1
		print("%s is now pregnant!" % chosen.name)
	else:
		print("%s and %s failed to get pregnant." % [npc1.name, npc2.name])

	npc1.attributes_changed.emit()
	npc2.attributes_changed.emit()
