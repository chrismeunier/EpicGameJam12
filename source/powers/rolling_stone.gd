extends Area2D

var speed : float = 20.0

func _on_timer_timeout() -> void:
	queue_free()

func _process(delta: float) -> void:
	global_position += Vector2(0, speed * delta)
