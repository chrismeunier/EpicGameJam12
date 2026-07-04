extends Node2D
@export var alpiniste_scene: PackedScene
@onready var climb_path: Path2D = $Chemin
@onready var enemies: Node2D = %Enemies

func _spawn_alpiniste() -> void:
	var a := alpiniste_scene.instantiate()
	$Enemies.add_child(a)
	a.setup(climb_path)

func _ready() -> void:
	_spawn_alpiniste()
