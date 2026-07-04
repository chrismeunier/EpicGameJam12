extends Node

@onready var guanaco_spit: Node = $Bullets/GuanacoSpit
@onready var avalanche: Node = $Towers/Avalanche
@onready var storm_1: AudioStreamPlayer = %Storm1
@onready var rock_1: AudioStreamPlayer = %Rock1
@onready var rock_2: AudioStreamPlayer = %Rock2
@onready var steps: Node = $Ennemies/Alpinist/Steps
@onready var guacano_theme: AudioStreamPlayer = %GuacanoTheme
@onready var menu_loop: AudioStreamPlayer = %MenuLoop
@onready var mountain: Node = %Mountain
@onready var death: Node = %Death
@onready var avalanche_1: AudioStreamPlayer = %Avalanche1
@onready var avalanche_2: AudioStreamPlayer = %Avalanche2
@onready var avalanche_3: AudioStreamPlayer = %Avalanche3

func play_guanaco_spit():
	var soundCount = guanaco_spit.get_child_count()
	var sound_index = randi() % soundCount
	guanaco_spit.get_child(sound_index).play()

func play_avalanche():
	if avalanche_1.playing || avalanche_2.playing || avalanche_3.playing:
		return
	var soundCount = avalanche.get_child_count()
	var sound_index = randi() % soundCount
	avalanche.get_child(sound_index).play()

func play_rock():
	# play rock1 sound once, then rock2 loop
	rock_1.play()

func _on_rock_1_finished() -> void:
	rock_2.play()

func stop_rock():
	rock_1.stop()
	rock_2.stop()

func play_foot_step():
	var soundCount = steps.get_child_count()
	var sound_index = randi() % soundCount
	steps.get_child(sound_index).play()
	
func play_alpinist_death():
	var soundCount = death.get_child_count()
	var sound_index = randi() % soundCount
	death.get_child(sound_index).play()
	
func play_mountain_scream():
	var soundCount = mountain.get_child_count()
	var sound_index = randi() % soundCount
	mountain.get_child(sound_index).play()
