extends Node2D

@export var condor_max_lifespan: float = 12.0
@export var condor_speed: float = 100.0
@export var condor_min_direction_time:float = 1.0
@export var condor_random_direction_change: float = 0.02

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var _path: Path2D
var _path_length: float
var _distance: float = 0.0
var _is_moving_right: bool = true
var _last_direction_change:float = 0.0
var _lifespan:float = 0.0

func setup(path: Path2D, start_left: bool = true) -> void:
	if _path == null:
		push_error(Error.ERR_INVALID_PARAMETER)

	_path = path
	_path_length = _path.curve.get_baked_length()

	if start_left:
		_distance = 0
		_is_moving_right = true
	else:
		_distance = 100
		_is_moving_right = false

	global_position = get_current_position()
	update_sprite_direction()

func _physics_process(delta: float) -> void:

	_lifespan += delta
	if _lifespan >= condor_max_lifespan:
		disapear()
		return

	if _is_moving_right:
		_distance += condor_speed * delta
	else:
		_distance -= condor_speed * delta

	if _distance >= 100.0:
		_is_moving_right = false
	elif _distance <= 0.0:
		_is_moving_right = true
	
	_last_direction_change += delta
	
	if _last_direction_change > condor_min_direction_time:
		_last_direction_change = 0
		if randf() <= condor_random_direction_change:
			_is_moving_right = not _is_moving_right

	update_sprite_direction()
	global_position = get_current_position()

func update_sprite_direction() -> void:
	if _is_moving_right:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

func get_current_position() -> Vector2:
	var curve_offset: float = _path_length * _distance/100.0
	var curve_position: Vector2 = _path.curve.sample_baked(curve_offset)
	return _path.to_global(curve_position)

func disapear() -> void:
	queue_free()
