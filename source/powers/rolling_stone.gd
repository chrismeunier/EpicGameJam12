extends Area2D

var speed : float = 30

func _process(delta: float) -> void:
	global_position += Vector2(0, speed * delta)

func _on_timer_timeout() -> void:
	AudioManager.stop_rock()
	queue_free()

func start_audio() -> void:
	AudioManager.play_rock()
