extends Node

@onready var guanaco_spit: Node = $Bullets/GuanacoSpit
@onready var avalanche: Node = $Towers/Avalanche

func play_guanaco_spit():
	# play one spit sound
	var nb_guanaco_spit_sounds = guanaco_spit.get_child_count()
	var sound_index = randi() % nb_guanaco_spit_sounds
	guanaco_spit.get_child(sound_index).play()

func play_avalanche():
	# play one spit sound
	var nb_avalanche_sounds = avalanche.get_child_count()
	var sound_index = randi() % nb_avalanche_sounds
	avalanche.get_child(sound_index).play()
