extends Node2D

@export var money: int = 5
@export var _lifePoints: int = 100
@export var money_wait_time:= 5
@export var dead_enemy_money_multiplier := 3

@onready var life_bar: ProgressBar = %LifeBar
@onready var money_timer: Timer = %MoneyTimer
@onready var enemies: Node2D = %Enemies
@onready var igloos: Node2D = %Igloos


func _ready() -> void:
	life_bar.max_value = _lifePoints
	life_bar.value = _lifePoints
	money_timer.wait_time = money_wait_time
	Events.summit_reached.connect(_on_summit_reached)
	Events.alpinist_died.connect(on_dead_alpinist)
	Events.bought_resource.connect(buy_something)
	Events.money_updated.emit(money)
	
	for igloo in igloos.get_children():
		igloo.hide()

func _on_timer_timeout() -> void:
	money += 1
	Events.money_updated.emit(money)

func _on_summit_reached(climber_lvl: int) -> void:
	AudioManager.play_mountain_scream()
	_lifePoints -= climber_lvl
	life_bar.value = _lifePoints
	_update_lifebar_color()
	_update_igloo_visibility()
	if _lifePoints <= 0:
		Events.game_over.emit()

func _update_lifebar_color():
	var ratio = life_bar.value / life_bar.max_value
	var style : StyleBox = life_bar.get_theme_stylebox("fill").duplicate()
	if ratio >= 0.8:
		return
	elif ratio < 0.1:
		style.bg_color = Color.RED
	elif ratio < 0.2:
		style.bg_color = Color.ORANGE_RED
	elif ratio < 0.5:
		style.bg_color = Color.ORANGE
	elif ratio < 0.8:
		style.bg_color = Color.YELLOW
	
	life_bar.add_theme_stylebox_override("fill", style)

func _update_igloo_visibility():
	var max_igloos = igloos.get_child_count()
	var visible_igloos = max_igloos - int(life_bar.value / life_bar.max_value * max_igloos)
	#print(visible_igloos, " igloos should be visible")
	for i in range(min(visible_igloos, max_igloos)):
		igloos.get_child(i).show()

func on_dead_alpinist(climber_lvl: int) -> void:
	money += climber_lvl * dead_enemy_money_multiplier
	Events.money_updated.emit(money)

func buy_something(price: int) -> bool:
	if price > money:
		return false
	
	money -= price
	Events.money_updated.emit(money)
	return true
