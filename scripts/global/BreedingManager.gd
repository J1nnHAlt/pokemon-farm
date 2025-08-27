extends Node

var npcs: Array = []

func register_npc(npc: NonPlayableCharacter):
	npcs.append(npc)
	npc.attributes_changed.connect(_on_attributes_changed.bind(npc))

func _on_attributes_changed(npc: NonPlayableCharacter):
	# Check if this NPC has Mating status
	if not npc.status.has(npc.PetStatus.Mating):
		return
	
	# Find another NPC with Mating status in the same nav region
	for other in npcs:
		if other == npc:
			continue
		if other.status.has(other.PetStatus.Mating):
			_breed(npc, other)
			break

func _breed(npc1: NonPlayableCharacter, npc2: NonPlayableCharacter):
	# Choose one randomly to get Pregnant
	var chosen = npc1 if randf() < 0.5 else npc2
	
	npc1.status.erase(npc1.PetStatus.Mating)
	npc2.status.erase(npc2.PetStatus.Mating)
	
	chosen.status[chosen.PetStatus.Pregnant] = 5  
	print("%s is now pregnant!" % chosen.name)
	
	npc1.attributes_changed.emit()
	npc2.attributes_changed.emit()
