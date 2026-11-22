extends Area2D

signal animation_ended

@export var impact_scene : PackedScene
@export var auto_delete_scene_timeout : float

@onready var animation: AnimatedSprite2D = %Animation

# besoin de répéter la texture ? ou de l'étendre en Y pour prendre tout l'écran ?

func _ready() -> void:
	# autoplay animation at startup
	# Delete scene after given time to cleanup resources
	get_tree().create_timer(auto_delete_scene_timeout).timeout.connect(_auto_delete)

func _auto_delete():
	call_deferred("queue_free")

func _on_animation_animation_finished() -> void:
	# Stop detecting impacts when the laser animation is over 
	monitoring = false
	monitorable = false
	animation_ended.emit()

func create_poop_impact_at_location(location: Vector2) -> void:
	var poop_effect : PoopVisualEffect = impact_scene.instantiate()
	poop_effect.global_position = location
	#print(poop_effect.name, poop_effect.global_position)
	add_child(poop_effect)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		#print(area.name, area.global_position)
		var vec_to_enemy = global_position - area.global_position
		create_poop_impact_at_location(-vec_to_enemy)
