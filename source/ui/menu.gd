class_name Menu
extends CanvasLayer

signal menu_play
signal menu_credits
signal back_to_menu

const LEVEL_SELECT_BUTTON = preload("res://source/ui/level_select_button.tscn")
# Add the level scenes in here: (from the inspector menu)
@export var level_list: Array[PackedScene] = []

@onready var main_menu_panel: PanelContainer = %MainMenuPanel
@onready var level_select_panel: PanelContainer = %LevelSelectPanel
@onready var level_button_container: HBoxContainer = %LevelButtonContainer
@onready var credits_panel: PanelContainer = %CreditsPanel


func _ready() -> void:
	level_select_panel.hide()
	credits_panel.hide()

	var level_id = 0
	for level_scene in level_list:
		var new_button = LEVEL_SELECT_BUTTON.instantiate()
		new_button.id = level_id
		level_button_container.add_child(new_button)
		level_id += 1

func _on_play_button_pressed() -> void:
	menu_play.emit()


func _on_credits_button_pressed() -> void:
	menu_credits.emit()


func _on_back_button_pressed() -> void:
	back_to_menu.emit()
