extends Node2D

# Drag and drop your Bulldozer .tscn scene file into this slot in the Inspector
@export var bulldozer_scene: PackedScene 
@onready var enemies: Node2D = %Enemies

# The precise Y destination you want the bulldozer to reach
@export var stop_at_y: float = 200.0
@export var edge_margin: float = 50.0 

func _ready() -> void:
	spawn_bulldozer()

func spawn_bulldozer() -> void:
	if not bulldozer_scene:
		return
	
	var bulldozer = bulldozer_scene.instantiate()

	# Calculate the screen dimensions, random spawn X, and center target X
	var viewport_rect = get_viewport_rect()
	var spawn_x = randf_range(edge_margin, viewport_rect.size.x - edge_margin)
	var spawn_y = viewport_rect.size.y + 0.0
	var center_x = viewport_rect.size.x / 2.0
	
	# Set positions and targets
	bulldozer.position = Vector2(spawn_x, spawn_y)
	bulldozer.target_x = center_x
	bulldozer.target_y = stop_at_y
	
	enemies.add_child(bulldozer)
	
	if bulldozer.has_method("setup"):
		bulldozer.setup()
	else:
		print("Spawner Error: The instanced buldozer is missing its setup() function!")
