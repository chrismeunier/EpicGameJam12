extends Area2D

func _on_timer_timeout() -> void:
	queue_free()

func start_audio() -> void:
	AudioManager.storm_1.play()
