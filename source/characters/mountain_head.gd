extends Node2D

const STATE_COUNT := 6
const DEAD_FRAME := 12
const EMPTY_FRAME := 13

@export var blink_frame_duration := 0.1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _base_frame := 0
var _is_dead := false
var _blink_tween: Tween


func _ready() -> void:
	sprite.stop()
	sprite.frame = 0
	Events.mountain_life_changed.connect(_on_mountain_life_changed)
	Events.game_over.connect(_die)


func _on_mountain_life_changed(ratio: float) -> void:
	if _is_dead:
		return
	if ratio <= 0.0:
		_die()
		return
	var state := clampi(int((1.0 - ratio) * STATE_COUNT), 0, STATE_COUNT - 1)
	_base_frame = state * 2
	_blink([_base_frame, EMPTY_FRAME, _base_frame + 1, EMPTY_FRAME, _base_frame])


func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	_blink([DEAD_FRAME, EMPTY_FRAME, DEAD_FRAME, EMPTY_FRAME, DEAD_FRAME])


func _blink(frames: Array) -> void:
	if _blink_tween:
		_blink_tween.kill()
	_blink_tween = create_tween()
	for f in frames:
		_blink_tween.tween_callback(sprite.set_frame.bind(f))
		_blink_tween.tween_interval(blink_frame_duration)
