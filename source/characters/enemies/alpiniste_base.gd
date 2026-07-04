extends Node2D
class_name AlpinisteBase

@export var lvl: int = 1

var speed: float = 50.0
var health: float = 100.0
var _base_speed: float = 50.0 

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var _path: Path2D
var _distance: float = 0.0
var _isInStorm: bool
var _isInAvalanch: bool
var _is_looping_steps: bool = false

var _current_direction_anim: String = "default"

func setup(path: Path2D, enemy_level: int = 1, start_distance: float = 0.0) -> void:
	_path = path
	_distance = start_distance
	lvl = enemy_level
	
	match lvl:
		1:
			health = 100.0
			_base_speed = 50.0
		2:
			health = 200.0
			_base_speed = 65.0
		3:
			health = 350.0
			_base_speed = 80.0
		_:
			health = 100.0 + (lvl * 100.0)
			_base_speed = 50.0 + (lvl * 15.0)
			
	speed = _base_speed
	global_position = _path.to_global(_path.curve.sample_baked(_distance))
	
	_update_sprite_animation()
	
	_is_looping_steps = true
	_loop_footsteps()

func _process(delta: float) -> void:
	if health <= 0.0:
		die()
		return
		
	if _isInStorm:
		speed = _base_speed * 0.2
	elif _isInAvalanch:
		health -= delta
		speed = _base_speed * 0.55
	else:
		speed = _base_speed

func _loop_footsteps() -> void:
	if not _is_looping_steps or health <= 0.0:
		return
	AudioManager.play_foot_step()
	var footstep_delay: float = clamp(50.0 / speed, 0.4, 1.2)
	await get_tree().create_timer(footstep_delay).timeout
	_loop_footsteps()
	
func _physics_process(delta: float) -> void:
	if _path == null:
		return

	_distance += speed * delta
	global_position = _path.to_global(_path.curve.sample_baked(_distance))

	var ahead := _path.to_global(_path.curve.sample_baked(_distance + 1.0))
	var rot: float = - (ahead - global_position).angle()

	if rot > 0 && rot < 0.75 * PI / 2:
		_current_direction_anim = "GoingNorthEast"
	elif rot >= 0.75 * PI / 2 && rot <= 1.25 * PI / 2:
		_current_direction_anim = "default"
	else:
		_current_direction_anim = "GoingNorthWest"

	_update_sprite_animation()

	if _distance >= _path.curve.get_baked_length():
		reach_summit()

func _update_sprite_animation() -> void:
	# 1. Safety check to make sure the resource is loaded
	if not animated_sprite or not animated_sprite.sprite_frames:
		return
		
	var final_animation_name = "Lvl" + str(lvl) + "_" + _current_direction_anim
	
	if animated_sprite.sprite_frames.has_animation(final_animation_name):
		animated_sprite.animation = final_animation_name
	else:
		var level_default = "Lvl" + str(lvl) + "_default"
		if animated_sprite.sprite_frames.has_animation(level_default):
			animated_sprite.animation = level_default
		else:
			# Ultimate fallback if no level assets are configured yet
			animated_sprite.animation = "default"

func reach_summit() -> void:
	Events.summit_reached.emit(lvl)
	queue_free()

func die() -> void:
	speed = 0
	queue_free()

func _on_area_entered(area: Area2D) -> void:
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
