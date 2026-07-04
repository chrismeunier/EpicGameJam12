class_name BaseLevel
extends Node2D

@export var level_id : int
@export var level_name := "Level"
@export var number_of_waves := 1

@export var wave_spawners: Array[WaveSpawner] = []

# Track how many spawners have finished all their waves
var completed_spawners: int = 0

func _ready() -> void:
	start_level()

func start_level() -> void:
	print("[DEBUG] Starting Level: ", level_name)
	
	if wave_spawners.is_empty():
		print("[DEBUG] ERROR: Cannot start level because wave_spawners array is empty!")
		return
		
	for spawner in wave_spawners:
		if is_instance_valid(spawner):
			print("[DEBUG] Calling start_spawner on: ", spawner.name)
			spawner.start_spawner(number_of_waves)
