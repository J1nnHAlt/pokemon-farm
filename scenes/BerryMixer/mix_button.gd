#extends Button
#
#@onready var mixer = $"../PanelContainer/MixerContent"  # Adjust if structure changes
#signal recipe_result(recipe_name: String)
#
#func _ready():
	#pressed.connect(on_mix_button_pressed)
#
#func on_mix_button_pressed():
	#var result = RecipeManager.find_matching_recipe(mixer.mixer_content)
#
	#emit_signal("recipe_result", result)
		#
	## Clear all mixer slots	
	#for slot in mixer.get_children():
		#slot.clear_data()
	## Reset mixer content
	#mixer.mixer_content.clear()	


extends Button

@onready var mixer = $"../PanelContainer/MixerContent"
signal recipe_result(recipe_name: String)

func _ready():
	pressed.connect(on_mix_button_pressed)

func on_mix_button_pressed():
	var result = RecipeManager.find_matching_recipe(mixer.mixer_content)
	emit_signal("recipe_result", result)
		
	# Clear all mixer slots	
	for slot in mixer.get_children():
		slot.clear_data()
	mixer.mixer_content.clear()
