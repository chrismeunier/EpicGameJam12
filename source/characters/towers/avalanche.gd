extends Area2D

@export var damage: int = 25

var targets: Array[Node2D] = []
@onready var avalanche_timer: Timer = $AvalancheTimer
@onready var snow_particles: CPUParticles2D = $SnowParticles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	avalanche_timer.timeout.connect(_on_avalanche_timer_timeout)

func _process(_delta: float) -> void:
	# Nettoie la liste si des ennemis meurent par autre chose
	targets = targets.filter(func(target): return is_instance_valid(target))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		targets.append(body)
		
		if avalanche_timer.is_stopped():
			trigger_avalanche()
			avalanche_timer.start(5.0)

func _on_body_exited(body: Node2D) -> void:
	targets.erase(body)

func _on_avalanche_timer_timeout() -> void:
	animated_sprite_2d.play("idle")
	if not targets.is_empty():
		trigger_avalanche()
	else:
		avalanche_timer.stop()

func trigger_avalanche() -> void:
	animated_sprite_2d.play("avalanche")
	snow_particles.restart()
	if AudioManager:
		AudioManager.play_avalanche() 

	for enemy in targets:
		if is_instance_valid(enemy) and enemy.has_method("take_damage"):
			enemy.take_damage(damage)
