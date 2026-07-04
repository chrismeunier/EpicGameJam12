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

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		# Check if enemy has a take_damage function, then destroy bullet
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
