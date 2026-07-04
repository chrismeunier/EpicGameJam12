extends Node2D
class_name AlpinisteBase

@export var speed: float = 60.0
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

var _path: Path2D
var _distance: float = 0.0

func setup(path: Path2D, start_distance: float = 0.0) -> void:
	_path = path
	_distance = start_distance
	global_position = _path.to_global(_path.curve.sample_baked(_distance))

func _physics_process(delta: float) -> void:
	if _path == null:
		return

	_distance += speed * delta
	global_position = _path.to_global(_path.curve.sample_baked(_distance))

	var ahead := _path.to_global(_path.curve.sample_baked(_distance + 1.0))
	var rot: float = -(ahead - global_position).angle()
	
	if rot > 0 && rot < 0.75 * PI / 2:
		animated_sprite_2d.animation = "GoingNorthEast"
	elif rot >= 0.75 * PI / 2 && rot <= 1.25 * PI / 2:
		animated_sprite_2d.animation = "default"
	else:
		animated_sprite_2d.animation = "GoingNorthWest"

	if _distance >= _path.curve.get_baked_length():
		_reach_summit()

func _reach_summit() -> void:
	#Events.climber_reached_summit.emit(self)
	queue_free()
