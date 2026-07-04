extends Node
# Autoload script
# Define all signals for communication between nodes
# when they are not hierarchically linked

# Level selection
signal selected_level(level_id: int)
# level starting
signal start_level

signal summit_reached(climber_lvl: int)

signal game_over

signal alpinist_died(climber_lvl: int)

signal money_updated(new_value: int)
signal bought_resource(price: int)
