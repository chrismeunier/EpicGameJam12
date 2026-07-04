class_name CoreController
extends Node

@export var menu: Menu

@onready var state_chart: StateChart = %StateChart

# usable state chart events:
# go_to_level_selection, go_to_credits
# level_selected
# start_wave
# wave_is_over
# wave_succeeded, wave_failed
# go_to_menu, retry_level

func _ready() -> void:
	menu.menu_play.connect(transit_to_level_select)
	menu.menu_credits.connect(transit_to_credits)
	menu.back_to_menu.connect(transit_to_menu)

#region Sending Events
func transit_to_menu():
	state_chart.send_event("go_to_menu")

func transit_to_level_select():
	state_chart.send_event("go_to_level_selection")

func transit_to_credits():
	state_chart.send_event("go_to_credits")
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
