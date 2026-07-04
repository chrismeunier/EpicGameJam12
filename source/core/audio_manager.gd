extends Node

@onready var guanaco_spit: Node = $Bullets/GuanacoSpit
@onready var avalanche: Node = $Towers/Avalanche
@onready var steps: Node = $Ennemies/Alpinist/Steps

func play_guanaco_spit():
	var nb_guanaco_spit_sounds = guanaco_spit.get_child_count()
	var sound_index = randi() % nb_guanaco_spit_sounds
	guanaco_spit.get_child(sound_index).play()

func play_avalanche():
	var nb_avalanche_sounds = avalanche.get_child_count()
	var sound_index = randi() % nb_avalanche_sounds
	avalanche.get_child(sound_index).play()

func play_foot_step():
	var nb_steps_sounds = steps.get_child_count()
	var sound_index = randi() % nb_steps_sounds
	steps.get_child(sound_index).play()
