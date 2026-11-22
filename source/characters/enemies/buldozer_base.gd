extends Area2D

var speed: float = 15.0
var health: float = 100.0
var _max_health: float = 100.0
var _base_speed: float = 10.0 

# Target coordinates where the bulldozer should stop
var target_x: float = 0.0
var target_y: float = 0.0
var has_reached_target: bool = false

var _isInStorm: bool
var _isInAvalanch: bool

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var health_bar: TextureProgressBar = %HealthBar

func _ready() -> void:
	if health_bar:
		health_bar.max_value = _max_health
		health_bar.value = health
		_update_health_bar()

func _process(delta: float) -> void:
	if not has_reached_target:
		var target_pos = Vector2(target_x, target_y)
		var direction = position.direction_to(target_pos)
		
		if animated_sprite and direction != Vector2.ZERO:
			animated_sprite.rotation = direction.angle() + PI / 2
		
		position = position.move_toward(target_pos, speed * delta)
		
		# Check if we have arrived at the exact target destination
		if position.is_equal_approx(target_pos):
			position = target_pos
			has_reached_target = true
			_on_target_reached()
	
	if health <= 0.0:
		die()
		return
	
	if _isInStorm:
		speed = _base_speed * 0.2
	elif _isInAvalanch:
		speed = _base_speed * 0.55
	else:
		speed = _base_speed
		
func setup() -> void:
	_max_health = health
	speed = _base_speed

func die() -> void:
	Events.buldozer_died.emit()
	speed = 0
	queue_free()

func _on_target_reached() -> void:
	Events.summit_reached.emit(10000)
	queue_free()
	
func _update_health_bar() -> void:
	if not health_bar:
		return
		
	health_bar.value = health
	
	var health_ratio = clamp(health / _max_health, 0.0, 1.0)
	
	if health_ratio > 0.5:
		# Health is high: Blend from Yellow to Green
		var weight = (health_ratio - 0.5) * 2.0
		health_bar.modulate = Color(1.0, 1.0, 0.0).lerp(Color(0.0, 1.0, 0.0), weight)
	else:
		# Health is low: Blend from Red to Yellow
		var weight = health_ratio * 2.0
		health_bar.modulate = Color(1.0, 0.0, 0.0).lerp(Color(1.0, 1.0, 0.0), weight)

func _on_area_entered(area: Area2D) -> void:
	print("on area entered buldozer :", area.get_groups())
	if area.is_in_group("Projectile"):
		health -= 2
		_update_health_bar()
	if area.is_in_group("RollingStone"):
		health -= 10
		_update_health_bar()
	if area.is_in_group("Storm"):
		_isInStorm = true
	if area.is_in_group("Avalanche"):
		health -= 4
		_update_health_bar()
		_isInAvalanch = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Storm"):
		_isInStorm = false
	if area.is_in_group("Avalanche"):
		_isInAvalanch = false
