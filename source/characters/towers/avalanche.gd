extends Area2D

var targets: Array[Node2D] = []
@onready var avalanche_timer: Timer = $AvalancheTimer
@onready var snow_particles: CPUParticles2D = $SnowParticles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	avalanche_timer.timeout.connect(_on_avalanche_timer_timeout)

func _process(_delta: float) -> void:
	# Nettoie la liste si des ennemis meurent par autre chose
	targets = targets.filter(func(target): return is_instance_valid(target))
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area)
		
		if avalanche_timer.is_stopped():
			trigger_avalanche()
			avalanche_timer.start(7.0)

func _on_area_exited(area: Area2D) -> void:
	targets.erase(area)

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
