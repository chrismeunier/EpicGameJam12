class_name Menu
extends CanvasLayer

signal menu_play
signal menu_credits
signal back_to_menu

const LEVEL_SELECT_BUTTON = preload("res://source/ui/level_select_button.tscn")
# Add the level scenes in here: (from the inspector menu)
@export var level_uid_list: Array[String] = []

@onready var main_menu_panel: PanelContainer = %MainMenuPanel
@onready var level_select_panel: PanelContainer = %LevelSelectPanel
@onready var level_button_container: HBoxContainer = %LevelButtonContainer
@onready var credits_panel: PanelContainer = %CreditsPanel


func _ready() -> void:
	level_select_panel.hide()
	credits_panel.hide()

	for level_uid in level_uid_list:
		# load the linked level via uid
		var level_scene : PackedScene = ResourceLoader.load(level_uid, "PackedScene") as PackedScene
		var level : BaseLevel = level_scene.instantiate() as BaseLevel
		# create the button
		var new_button = LEVEL_SELECT_BUTTON.instantiate()
		# assign the level to the button -> writes name and more
		new_button.level = level
		level_button_container.add_child(new_button)

func _on_play_button_pressed() -> void:
	menu_play.emit()


func _on_credits_button_pressed() -> void:
	menu_credits.emit()


func _on_back_button_pressed() -> void:
	back_to_menu.emit()
