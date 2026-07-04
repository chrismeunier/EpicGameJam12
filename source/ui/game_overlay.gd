extends CanvasLayer


@onready var main_panel: PanelContainer = %MainPanel


func _on_start_level_button_pressed() -> void:
	Events.start_level.emit()
