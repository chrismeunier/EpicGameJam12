extends Area2D

var projectile_scene = preload("res://source/characters/towers/bullets/guanaco_spit.tscn")

var targets: Array[Node2D] = [] # Tracks enemies inside the range
var current_target: Node2D = null

@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: AnimatedSprite2D = %Sprite2D
@onready var mouth: Marker2D = %Mouth

func _ready() -> void:
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _process(_delta: float) -> void:
	_update_target()
	if current_target and shoot_timer.is_stopped():
		shoot_timer.start()

func _update_target() -> void:
	# Clean up any destroyed or invalid enemies from our list
	targets = targets.filter(func(target): return is_instance_valid(target))
	
	if targets.is_empty():
		current_target = null
		shoot_timer.stop()
		sprite.stop()
	else:
		# Target the first enemy that entered the range
		current_target = targets[0]
		sprite.play("default")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area)

func _on_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _on_shoot_timer_timeout() -> void:
	if is_instance_valid(current_target):
		shoot_projectile()
		shoot_timer.start() # Restart timer for the next shot

func shoot_projectile() -> void:
	if not projectile_scene:
		print("Missing projectile scene!")
		return
		
	# Instance the bullet and add it to the main game loop
	var bullet = projectile_scene.instantiate()
	bullet.global_position = mouth.global_position
	bullet.target = current_target
	get_tree().current_scene.add_child(bullet)
	
	if (current_target.global_position.x - global_position.x) < 0:
		scale.x = -1
	else:
		scale.x = 1
	
	if AudioManager:
		AudioManager.play_guanaco_spit() 
