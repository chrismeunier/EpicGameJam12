extends Node2D
class_name WaveSpawner

@export var alpiniste_scene: PackedScene
@export var road: Path2D 

@onready var enemies: Node2D = %Enemies
@onready var spawn_timer: Timer = $SpawnTimer

# Wave Configuration
var current_wave: int = 1
var enemies_left_to_spawn: int = 0
var wave_running: bool = false
var max_waves: int = 1 # Controlled by BaseLevel

func _ready() -> void:
	# Connects the timer signal safely
	if spawn_timer:
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func start_spawner(total_waves: int) -> void:
	max_waves = total_waves
	current_wave = 1
	start_next_wave()

func start_next_wave() -> void:
	wave_running = true
	enemies_left_to_spawn = current_wave * 5 
	print("--- STARTING WAVE ", current_wave, "/", max_waves, " (Enemies: ", enemies_left_to_spawn, ") ---")
	
	if spawn_timer:
		spawn_timer.start(1.5)

func _on_spawn_timer_timeout() -> void:
	if enemies_left_to_spawn > 0:
		spawn_enemy()
		enemies_left_to_spawn -= 1
		
		if enemies_left_to_spawn > 0 and spawn_timer:
			spawn_timer.start()
		else:
			_end_wave()

func spawn_enemy() -> void:
	if not alpiniste_scene or not enemies or not road:
		print("Spawner Error: Missing alpiniste_scene, %Enemies, or road reference!")
		return
	
	var enemy_level: int = 1
	if current_wave >= 6:
		enemy_level = 3     
	elif current_wave >= 3:
		enemy_level = 2     
	else:
		enemy_level = 1     
		
	var a = alpiniste_scene.instantiate()
	enemies.add_child(a)
	
	if a.has_method("setup"):
		a.setup(road, enemy_level)
	else:
		print("Spawner Error: The instanced alpinist is missing its setup() function!")

func _end_wave() -> void:
	wave_running = false
	print("Wave spawning complete! Waiting for next wave...")
	
	if current_wave >= max_waves:
		print("All waves sent successfully!")
		Events.all_waves_ended.emit()
		return
	
	Events.money_added.emit(25 + (5 * current_wave))
	await get_tree().create_timer(10.0).timeout
	current_wave += 1
	start_next_wave()
