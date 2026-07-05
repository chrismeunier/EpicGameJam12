class_name ClickableResource
extends Control

@export var icon : Texture2D
@export var resource_scene : PackedScene
@export var cost := 0
@export var clearance_radius := 32.0

@export var restrict_to_placement_zones: bool = true

var available := false : set = refresh_availability
var preview_resource : Area2D = null
var placing_resource = false
var parent_node_for_placing : BaseLevel = null

@onready var usable_resource: UsableResource = %UsableResource
@onready var button: Button = %Button

func _ready() -> void:
	Events.money_updated.connect(update_availability)
	button.size = Vector2(92.0, 168.0)
	if not available:
		button.disabled = true
		_activate_transparency()
		
	usable_resource.resource_icon.texture = icon
	usable_resource.cost_text.text = "X " + str(cost)

func _process(_delta: float) -> void:
	if placing_resource and preview_resource:
		var parent_node = preview_resource.get_parent()
		if parent_node:
			preview_resource.position = parent_node.get_local_mouse_position()
		else:
			preview_resource.global_position = get_global_mouse_position()
		
		# Visual preview feedback
		if _is_spot_valid(preview_resource.global_position):
			preview_resource.modulate = Color(0.3, 1.0, 0.3, 0.7) # Green
		else:
			preview_resource.modulate = Color(1.0, 0.3, 0.3, 0.7) # Red

func _input(event: InputEvent) -> void:
	if placing_resource and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_cancel_placement()
		return

	if placing_resource and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target_pos = preview_resource.global_position
		
		if _is_spot_valid(target_pos):
			preview_resource.global_position = target_pos
			preview_resource.add_to_group("BuiltTowers")
			
			if preview_resource.has_method("start_audio"):
				preview_resource.start_audio()
				
			preview_resource.process_mode = Node.PROCESS_MODE_INHERIT
			preview_resource.modulate = Color(1.0, 1.0, 1.0, 1.0)
			preview_resource.self_modulate.a = 1.0
			
			placing_resource = false
			preview_resource = null
			print("[PLACEMENT] Success! Tower deployed.")
		else:
			print("[PLACEMENT] Denied: Invalid ground or blocking another tower.")

func _on_button_pressed() -> void:
	Events.bought_resource.emit(cost)
	preview_resource = resource_scene.instantiate() as Area2D
	
	var target_parent_node: Node = null
	var current_scene = get_tree().current_scene
	
	if current_scene:
		var level_root_node = current_scene.find_child("LevelRoot", true, false)
		if level_root_node and level_root_node.get_child_count() > 0:
			target_parent_node = level_root_node.get_child(0) 

	if target_parent_node:
		target_parent_node.add_child(preview_resource)
	else:
		if current_scene:
			current_scene.add_child(preview_resource)
		else:
			add_child(preview_resource)
		
	preview_resource.process_mode = Node.PROCESS_MODE_DISABLED
	preview_resource.modulate = Color(1.0, 1.0, 1.0, 0.6)
	
	await get_tree().process_frame
	placing_resource = true

func _is_spot_valid(pos: Vector2) -> bool:
	var inside_valid_zone := false
	
	if not restrict_to_placement_zones:
		return true
	else:
		if preview_resource and preview_resource.get_parent():
			var lvl1_node = preview_resource.get_parent()
			var folder_node = lvl1_node.find_child("PlacementZone", true, false)
			
			if folder_node:
				for child in folder_node.get_children():
					if child is CollisionPolygon2D:
						var local_pos = child.to_local(pos)
						if Geometry2D.is_point_in_polygon(local_pos, child.polygon):
							inside_valid_zone = true
							break 

	if not inside_valid_zone:
		return false
		
	var built_towers = get_tree().get_nodes_in_group("BuiltTowers")
	for tower in built_towers:
		if is_instance_valid(tower) and tower != preview_resource:
			if pos.distance_to(tower.global_position) < clearance_radius:
				return false 
				
	return true

func _cancel_placement() -> void:
	if preview_resource:
		preview_resource.queue_free()
	preview_resource = null
	placing_resource = false
	print("[PLACEMENT] Canceled.")

func refresh_availability(val: bool):
	available = val
	if not available:
		button.disabled = true
		_activate_transparency()
	else:
		button.disabled = false
		_deactivate_transparency()

func _activate_transparency():
	usable_resource.modulate.a = 0.5

func _deactivate_transparency():
	usable_resource.modulate.a = 1.0

func update_availability(current_resource: int):
	available = current_resource >= cost
