extends Node2D

@export var money: int = 5
@onready var life_bar: ProgressBar = %LifeBar

var _lifePoints: int = 100

func _ready() -> void:
	life_bar.max_value = _lifePoints
	life_bar.value = _lifePoints
	Events.summit_reached.connect(_on_summit_reached)
	Events.alpinist_died.connect(on_dead_alpinist)

func _on_timer_timeout() -> void:
	money += 1

func _on_summit_reached(climber_lvl: int) -> void:
	AudioManager.play_mountain_scream()
	_lifePoints -= climber_lvl
	life_bar.value = _lifePoints
	if _lifePoints <= 0:
		Events.game_over.emit()

func on_dead_alpinist(climber_lvl: int) -> void:
	money += climber_lvl * 5

func buy_something(price: int) -> bool:
	if price > money:
		return false
	
	money -= price
	return true
