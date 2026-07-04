extends Node
class_name CoreController

@onready var state_chart: StateChart = %StateChart

# usable state chart events:
# go_to_level_selection, go_to_credits
# level_selected
# start_wave
# wave_is_over
# wave_succeeded, wave_failed
# go_to_menu, retry_level

func _ready() -> void:
	Events.menu_play.connect(transit_to_level_select)
	Events.menu_credits.connect(transit_to_credits)
	

func transit_to_level_select():
	state_chart.send_event("go_to_level_selection")

func transit_to_credits():
	state_chart.send_event("go_to_credits")
