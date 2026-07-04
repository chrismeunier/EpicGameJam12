class_name ClickableResource
extends Control

@export var icon : Texture2D
@export var resource_scene : PackedScene
@export var cost := 0

var available := false : set = refresh_availability
var preview_resource : Area2D = null
var placing_resource = false
var parent_node_for_placing : BaseLevel = null

@onready var usable_resource: UsableResource = %UsableResource
@onready var button: Button = %Button


func _ready() -> void:
	Events.money_updated.connect(update_availability)
	# hardcoded because fuck it no dynamic resizing wants to work
	button.size = Vector2(92.0, 168.0)
	if not available:
		button.disabled = true
		modulate.a = 0.5
	# Apply the image to the texture rect
	usable_resource.resource_icon.texture = icon
	# Update the cost visually
	usable_resource.cost_text.text = "X " + str(cost)


func _process(_delta: float) -> void:
	if placing_resource and preview_resource:
		preview_resource.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if placing_resource and event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			if preview_resource.has_method("start_audio"):
				preview_resource.start_audio()
			preview_resource.global_position = get_global_mouse_position()
			preview_resource.process_mode = Node.PROCESS_MODE_INHERIT
			preview_resource = null
			placing_resource = false

func _on_button_pressed() -> void:
	Events.bought_resource.emit(cost)
	preview_resource = resource_scene.instantiate() as Area2D
	# add it elsewhere ?
	if parent_node_for_placing:
		parent_node_for_placing.add_child(preview_resource)
	else:
		add_child(preview_resource)
	preview_resource.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	placing_resource = true

func refresh_availability(val:bool):
	available = val
	if not available:
		button.disabled = true
		modulate.a = 0.5
	else:
		button.disabled = false
		modulate.a = 1.0


func update_availability(current_resource: int):
	if current_resource < cost:
		available = false
	else:
		available = true
