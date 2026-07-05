class_name CoreController
extends Node

const CONFIG_PATH = "user://progress.cfg"
static var _current_level : BaseLevel
@export var menu: Menu
@export var level_root: Node
@export var game_overlay : Overlay

var selected_level_id := 0
var config := ConfigFile.new()

@onready var state_chart: StateChart = %StateChart

# usable state chart events:
# go_to_level_selection, go_to_credits
# level_selected
# start_wave
# wave_is_over
# wave_succeeded, wave_failed
# go_to_menu

func _ready() -> void:
	game_overlay.hide()
	menu.menu_play.connect(transit_to_level_select)
	menu.menu_credits.connect(transit_to_credits)
	menu.back_to_menu.connect(transit_to_menu)
	menu.retry_level.connect(reload_level)
	Events.selected_level.connect(load_new_level)
	Events.start_level.connect(start_wave)
	Events.all_waves_ended.connect(transit_to_end_of_waves)
	Events.no_more_enemies_on_map.connect(transit_to_success)
	Events.game_over.connect(transit_to_failure)
	
	if config.load(CONFIG_PATH) != OK:
		config.set_value("levels", "succeeded", [false, false, false])
		config.set_value("levels", "score", [0, 0, 0])
		config.save(CONFIG_PATH)
	menu.config = config

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

func reload_level():
	load_new_level(_current_level.level_id)

func unload_current_level():
	if not _current_level:
		push_error("No current level to unload!")
	_current_level.call_deferred("queue_free")

func start_wave():
	state_chart.send_event("start_wave")

func transit_to_end_of_waves():
	state_chart.send_event("wave_is_over")

func transit_to_success():
	state_chart.send_event("wave_succeeded")

func transit_to_failure():
	state_chart.send_event("wave_failed")
#endregion

#region Start/stop process
func block_current_level():
	#! STOP THE LEVEL FROM RUNNING AUTOMATICALLY
	_current_level.process_mode = Node.PROCESS_MODE_DISABLED

func process_current_level():
	_current_level.process_mode = Node.PROCESS_MODE_INHERIT

#endregion

#region MainMenu
func _on_main_menu_state_entered() -> void:
	AudioManager.guacano_theme.stop()
	if not AudioManager.menu_loop.playing:
		AudioManager.menu_loop.play(1.0)
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
	block_current_level()
	level_root.add_child(_current_level)
	await get_tree().process_frame

#endregion

#region Start playing

func _on_playing_state_entered() -> void:
	game_overlay.show()
	game_overlay.start_level_button.disabled = false
	game_overlay.start_level_button.modulate = Color(1, 1, 1, 1)

func _on_before_wave_start_state_entered() -> void:
	load_level()
	menu.main_menu_panel.hide()
#endregion

#region Start wave
func _on_enemy_wave_active_state_entered() -> void:
	AudioManager.menu_loop.stop()
	if not AudioManager.guacano_theme.playing:
		AudioManager.guacano_theme.play(2.0)
	game_overlay.start_level_button.disabled = true
	game_overlay.start_level_button.modulate = Color(0.5, 0.5, 0.5, 0.5)
	# Reset the standard process mode -> level can run
	game_overlay.apply_current_level(_current_level)
	process_current_level()

#endregion

#region End of the game/level
func _on_playing_state_exited() -> void:
	AudioManager.guacano_theme.stop()
	AudioManager.stop_rock()
	AudioManager.storm_1.stop()
	if not AudioManager.menu_loop.playing:
		AudioManager.menu_loop.play(1.0)
	block_current_level()
	game_overlay.hide()

# Game over: success !
func _on_game_over_success_state_entered() -> void:
	menu.level_success_panel.show()
	var progression : Array = config.get_value("levels", "succeeded")
	progression[_current_level.level_id] = true
	config.set_value("levels", "succeeded", progression)
	var scores : Array = config.get_value("levels", "score")
	scores[_current_level.level_id] = _current_level.score
	config.set_value("levels", "score", scores)
	config.save(CONFIG_PATH)
	

func _on_game_over_success_state_exited() -> void:
	menu.main_menu_panel.show()
	unload_current_level()
	menu.level_success_panel.hide()

# Game over: failed...
func _on_game_over_failed_state_entered() -> void:
	menu.game_over_panel.show()

func _on_game_over_failed_state_exited() -> void:
	menu.main_menu_panel.show()
	unload_current_level()
	menu.game_over_panel.hide()

#endregion
