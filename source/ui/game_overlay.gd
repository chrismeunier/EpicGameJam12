class_name Overlay
extends CanvasLayer


@onready var main_panel: PanelContainer = %MainPanel
@onready var start_level_button: TextureButton = %StartLevelButton
@onready var resources_count: Label = %ResourcesCount
@onready var towers: HBoxContainer = %Towers
@onready var powers: HBoxContainer = %Powers

func _ready() -> void:
	Events.money_updated.connect(update_resources_count)

# Allows to have new towers and power added in the level scene
func apply_current_level(level:BaseLevel):
	for tower in towers.get_children():
		tower.parent_node_for_placing = level
	for power in powers.get_children():
		power.parent_node_for_placing = level

func disable_powers():
	for power in powers.get_children():
		power.available = false

func _on_start_level_button_pressed() -> void:
	Events.start_level.emit()

func update_resources_count(new_value:int):
	resources_count.text = "X " + str(new_value)
