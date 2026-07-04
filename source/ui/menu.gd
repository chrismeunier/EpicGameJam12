class_name Menu
extends CanvasLayer

signal menu_play
signal menu_credits
signal back_to_menu
signal retry_level

const LEVEL_SELECT_BUTTON = preload("res://source/ui/level_select_button.tscn")
# Add the level scenes in here: (from the inspector menu)
@export var level_uid_list: Array[String] = []

@onready var main_menu_panel: PanelContainer = %MainMenuPanel
@onready var level_select_panel: PanelContainer = %LevelSelectPanel
@onready var level_button_container: HBoxContainer = %LevelButtonContainer
@onready var credits_panel: PanelContainer = %CreditsPanel
@onready var main_buttons: HBoxContainer = %MainButtons
@onready var level_success_panel: PanelContainer = %LevelSuccessPanel
@onready var game_over_panel: PanelContainer = %GameOverPanel

func _ready() -> void:
	level_select_panel.hide()
	credits_panel.hide()
	level_success_panel.hide()
	game_over_panel.hide()
	
	for level_uid in level_uid_list:
		# load the linked level via uid
		var level_scene : PackedScene = ResourceLoader.load(level_uid, "PackedScene") as PackedScene
		var level : BaseLevel = level_scene.instantiate() as BaseLevel
		# create the button
		var new_button = LEVEL_SELECT_BUTTON.instantiate()
		# assign the level to the button -> writes name and more
		level_button_container.add_child(new_button)
		new_button.setup(level)

func _on_play_button_pressed() -> void:
	main_buttons.hide()
	menu_play.emit()

func _on_credits_button_pressed() -> void:
	menu_credits.emit()

func _on_back_button_pressed() -> void:
	main_buttons.show()
	back_to_menu.emit()

func _on_level_select_button_pressed() -> void:
	menu_play.emit()

func _on_retry_button_pressed() -> void:
	retry_level.emit()
