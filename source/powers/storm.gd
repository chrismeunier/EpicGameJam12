extends Area2D

func _ready() -> void:
	AudioManager.storm_1.play()

func _on_timer_timeout() -> void:
	queue_free()
