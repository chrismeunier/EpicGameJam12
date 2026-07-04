extends Area2D

var speed : float = 30

func _ready() -> void:
	AudioManager.play_rock()

func _process(delta: float) -> void:
	global_position += Vector2(0, speed * delta)

func _on_timer_timeout() -> void:
	queue_free()
