class_name Overlay
extends CanvasLayer


@onready var main_panel: PanelContainer = %MainPanel
@onready var start_level_button: TextureButton = %StartLevelButton
@onready var resources_count: Label = %ResourcesCount



func _on_start_level_button_pressed() -> void:
	Events.start_level.emit()
