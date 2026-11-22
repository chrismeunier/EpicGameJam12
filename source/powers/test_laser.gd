extends Node2D

@export var laser_scene : PackedScene
@export var impact_scene : PackedScene

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var pos = get_global_mouse_position()
		var scene = null
		#print(pos, event.button_mask)
		match event.button_mask:
			MOUSE_BUTTON_LEFT:
				scene = laser_scene
			MOUSE_BUTTON_RIGHT:
				scene = impact_scene
		if scene:
			var effect = scene.instantiate()
			effect.global_position = pos
			add_child(effect)
			
