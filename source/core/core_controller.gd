class_name CoreController
extends Node

static var _current_level : BaseLevel
@export var menu: Menu
@export var level_root: Node
@export var game_overlay : CanvasLayer
var selected_level_id: int = 0
@onready var state_chart: StateChart = %StateChart

# usable state chart events:
# go_to_level_selection, go_to_credits
# level_selected
# start_wave
# wave_is_over
# wave_succeeded, wave_failed
# go_to_menu, retry_level

func _ready() -> void:
	game_overlay.hide()
	menu.menu_play.connect(transit_to_level_select)
	menu.menu_credits.connect(transit_to_credits)
	menu.back_to_menu.connect(transit_to_menu)
	Events.selected_level.connect(load_new_level)
	Events.start_level.connect(start_wave)

#region Sending Events
func transit_to_menu():
	state_chart.send_event("go_to_menu")

func transit_to_level_select():
	state_chart.send_event("go_to_level_selection")

func transit_to_credits():
	state_chart.send_event("go_to_credits")
	
func load_new_level(id:int):
	selected_level_id = id
	state_chart.send_event("level_selected")

func start_wave():
	state_chart.send_event("start_wave")
#endregion

#region MainMenu
func _on_main_menu_state_entered() -> void:
	AudioManager.guacano_theme.stop()
	AudioManager.menu_loop.play()
#endregion

#region LevelSelect
func _on_level_select_state_entered() -> void:
	menu.level_select_panel.show()

func _on_level_select_state_exited() -> void:
	menu.level_select_panel.hide()
#endregion

#region Credits
func _on_credits_state_entered() -> void:
	menu.credits_panel.show()

func _on_credits_state_exited() -> void:
	menu.credits_panel.hide()
#endregion

#region Load level
func load_level():
	_deferred_load_level.call_deferred()

func _deferred_load_level():
	var new_level_uid = menu.level_uid_list[selected_level_id]
	var new_level_scene : PackedScene = ResourceLoader.load(new_level_uid, "PackedScene") as PackedScene
	
	if _current_level != null:
		# Remove the previous level and wait if needed
		_current_level.queue_free()
		_current_level = null
		await get_tree().process_frame
	
	_current_level = new_level_scene.instantiate() as BaseLevel
	#! STOP THE LEVEL FROM RUNNING AUTOMATICALLY
	_current_level.process_mode = Node.PROCESS_MODE_DISABLED
	
	level_root.add_child(_current_level)
	await get_tree().process_frame

#endregion

#region Start playing

func _on_playing_state_entered() -> void:
	game_overlay.show()
	AudioManager.menu_loop.stop()
	AudioManager.guacano_theme.play()

func _on_before_wave_start_state_entered() -> void:
	load_level()
	menu.main_menu_panel.hide()
#endregion

#region Start wave
func _on_enemy_wave_active_state_entered() -> void:
	# Reset the standard process mode -> level can run
	_current_level.process_mode = Node.PROCESS_MODE_INHERIT
	
#endregion

#region End of the game/level
func _on_playing_state_exited() -> void:
	game_overlay.hide()

#endregion
