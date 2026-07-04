class_name Overlay
extends CanvasLayer


@onready var main_panel: PanelContainer = %MainPanel
@onready var start_level_button: TextureButton = %StartLevelButton
@onready var resources_count: Label = %ResourcesCount
@onready var towers: HBoxContainer = %Towers
@onready var powers: HBoxContainer = %Powers

# Allows to have new towers and power added in the level scene
func apply_current_level(level:BaseLevel):
	for tower in towers.get_children():
		tower.parent_node_for_placing = level
	for power in powers.get_children():
		power.parent_node_for_placing = level

func _on_start_level_button_pressed() -> void:
	Events.start_level.emit()
