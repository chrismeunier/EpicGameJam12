class_name BaseLevel
extends Node2D

@export var level_id : int
@export var level_name := "Level"
@export var number_of_waves := 1

@export var wave_spawners: Array[WaveSpawner] = []

var enemies: Node2D = null

# Track how many spawners have finished all their waves
var completed_spawners: int = 0

func _ready() -> void:
	start_level()
	enemies = get_node("%Enemies")
	enemies.child_exiting_tree.connect(_on_enemies_child_exiting_tree)
	if not enemies:
		push_error("Level must have a Node2D named Enemies")

func start_level() -> void:
	print("[DEBUG] Starting Level: ", level_name)
	
	if wave_spawners.is_empty():
		print("[DEBUG] ERROR: Cannot start level because wave_spawners array is empty!")
		return
		
	for spawner in wave_spawners:
		if is_instance_valid(spawner):
			print("[DEBUG] Calling start_spawner on: ", spawner.name)
			spawner.start_spawner(number_of_waves)


func _on_enemies_child_exiting_tree(node: Node) -> void:
	#print(node, " exited tree")
	#print(enemies.get_child_count(), " remaining enemies")
	# weird bug: it counts down to one even if the node has no child
	if enemies.get_child_count() <= 1:
		Events.no_more_enemies_on_map.emit()
