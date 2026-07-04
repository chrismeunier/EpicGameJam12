extends Area2D

var target: Node2D = null
var speed: float = 400.0
var damage: int = 0

func _process(delta: float) -> void:
	# If the enemy dies before the bullet hits, destroy the bullet
	if not is_instance_valid(target):
		queue_free()
		return
		
	# Move directly toward the enemy
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("Enemy"):
		queue_free()
