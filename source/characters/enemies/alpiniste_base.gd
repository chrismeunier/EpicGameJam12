extends Node2D
class_name AlpinisteBase

const lvl: int = 1

@export var speed: float = 50.0
@export var health: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var _path: Path2D
var _distance: float = 0.0
var _isInStorm: bool
var _isInAvalanch: bool

func setup(path: Path2D, start_distance: float = 0.0) -> void:
	_path = path
	_distance = start_distance
	global_position = _path.to_global(_path.curve.sample_baked(_distance))

func _process(delta: float) -> void:
	if health <= 0.0:
		die()
		return
	if _isInStorm:
		speed = 10.0
	elif _isInAvalanch:
		health -= delta
		speed = 30.0
	else:
		speed = 50.0

func _physics_process(delta: float) -> void:
	if _path == null:
		return

	_distance += speed * delta
	global_position = _path.to_global(_path.curve.sample_baked(_distance))

	var ahead := _path.to_global(_path.curve.sample_baked(_distance + 1.0))
	var rot: float = - (ahead - global_position).angle()

	if rot > 0 && rot < 0.75 * PI / 2:
		animated_sprite.animation = "GoingNorthEast"
	elif rot >= 0.75 * PI / 2 && rot <= 1.25 * PI / 2:
		animated_sprite.animation = "default"
	else:
		animated_sprite.animation = "GoingNorthWest"

	if _distance >= _path.curve.get_baked_length():
		reach_summit()

func reach_summit() -> void:
	Events.summit_reached.emit(lvl)
	queue_free()

func die() -> void:
	speed = 0
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	# print(area)
	if area.is_in_group("Projectile"):
		health -= 15
	if area.name == "RollingStone":
		health -= 50
	if area.name == "Storm":
		_isInStorm = true
	if area.is_in_group("Slowness"):
		_isInAvalanch = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "Storm":
		_isInStorm = false
	if area.is_in_group("Slowness"):
		_isInAvalanch = false
