extends InvItem

class_name PetFood

@export_enum("Growth", "Breed", "Evolve") var type: String
@export_enum("Dark", "Grass", "Water", "Special") var element: String
@export_enum("Common", "Rare", "Epic", "Legendary") var rarity: String
