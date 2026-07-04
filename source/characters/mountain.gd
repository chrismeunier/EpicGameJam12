extends Node2D

@export var money: int = 5
@export var _lifePoints: int = 100
@export var money_wait_time:= 5

@onready var life_bar: ProgressBar = %LifeBar
@onready var money_timer: Timer = %MoneyTimer
@onready var enemies: Node2D = %Enemies


func _ready() -> void:
	life_bar.max_value = _lifePoints
	life_bar.value = _lifePoints
	money_timer.wait_time = money_wait_time
	Events.summit_reached.connect(_on_summit_reached)
	Events.alpinist_died.connect(on_dead_alpinist)
	Events.bought_resource.connect(buy_something)
	Events.money_updated.emit(money)

func _on_timer_timeout() -> void:
	money += 1
	Events.money_updated.emit(money)

func _on_summit_reached(climber_lvl: int) -> void:
	AudioManager.play_mountain_scream()
	_lifePoints -= climber_lvl
	life_bar.value = _lifePoints
	if _lifePoints <= 0:
		Events.game_over.emit()

func on_dead_alpinist(climber_lvl: int) -> void:
	money += climber_lvl * 5
	Events.money_updated.emit(money)

func buy_something(price: int) -> bool:
	if price > money:
		return false
	
	money -= price
	Events.money_updated.emit(money)
	return true
