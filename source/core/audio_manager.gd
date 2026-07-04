extends Node

@onready var guanaco_spit: Node = $Bullets/GuanacoSpit
@onready var avalanche: Node = $Towers/Avalanche
@onready var storm_1: AudioStreamPlayer = %Storm1
@onready var rock_1: AudioStreamPlayer = %Rock1
@onready var rock_2: AudioStreamPlayer = %Rock2

func play_guanaco_spit():
	# play one spit sound
	var nb_guanaco_spit_sounds = guanaco_spit.get_child_count()
	var sound_index = randi() % nb_guanaco_spit_sounds
	guanaco_spit.get_child(sound_index).play()

func play_avalanche():
	# play avalanche sound once
	var nb_avalanche_sounds = avalanche.get_child_count()
	var sound_index = randi() % nb_avalanche_sounds
	avalanche.get_child(sound_index).play()

func play_rock():
	# play rock1 sound once, then rock2 loop
	rock_1.play()

func _on_rock_1_finished() -> void:
	rock_2.play()

func stop_rock():
	rock_1.stop()
	rock_2.stop()
