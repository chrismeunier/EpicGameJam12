extends Node2D

@export var alpiniste_scene: PackedScene
@onready var enemies: Node2D = %Enemies
@onready var chemin: Path2D = %Chemin

@onready var spawn_timer: Timer = $SpawnTimer

# Wave Configuration
var current_wave: int = 1
var enemies_left_to_spawn: int = 0
var wave_running: bool = false

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	# Start the very first wave automatically after 2 seconds
	await get_tree().create_timer(2.0).timeout
	start_next_wave()

func start_next_wave() -> void:
	wave_running = true
	# Scale wave difficulty: Wave 1 = 5 enemies, Wave 2 = 10, etc.
	enemies_left_to_spawn = current_wave * 5 
	print("--- STARTING WAVE ", current_wave, " (Enemies: ", enemies_left_to_spawn, ") ---")
	
	# Set time gap between individual enemy spawns (e.g., 1.5 seconds)
	spawn_timer.start(1.5)

func _on_spawn_timer_timeout() -> void:
	if enemies_left_to_spawn > 0:
		spawn_enemy()
		enemies_left_to_spawn -= 1
		
		# If more enemies remain, restart the gap timer
		if enemies_left_to_spawn > 0:
			spawn_timer.start()
		else:
			_end_wave()

func spawn_enemy() -> void:
	if not alpiniste_scene or not enemies or not chemin:
		return
	
	var a := alpiniste_scene.instantiate()
	enemies.add_child(a)
	a.setup(chemin)


func _end_wave() -> void:
	wave_running = false
	print("Wave spawning complete! Waiting for next wave...")
	
	# Wait 10 seconds of peace before starting the next harder wave
	await get_tree().create_timer(10.0).timeout
	current_wave += 1
	start_next_wave()
