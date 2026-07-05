extends Area2D

var speed : float = 50

func _process(delta: float) -> void:
	global_position += Vector2(0, speed * delta)
	if global_position.y > 848:
		AudioManager.stop_rock()
		queue_free()

func start_audio() -> void:
	AudioManager.play_rock()
