extends CanvasLayer
class_name Menu


func _on_play_button_pressed() -> void:
	Events.menu_play.emit()


func _on_credits_button_pressed() -> void:
	Events.menu_credits.emit()
