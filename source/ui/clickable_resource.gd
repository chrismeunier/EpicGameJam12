class_name ClickableResource
extends Control

@export var icon : Texture2D
@export var resource_scene : PackedScene
@export var available := false # to disable it

var preview_resource : Area2D = null
var placing_resource = false

@onready var usable_resource: UsableResource = %UsableResource
@onready var button: Button = %Button


func _ready() -> void:
	# hardcoded because fuck it no dynamic resizing wants to work
	button.size = Vector2(92.0, 168.0)
	if not available:
		button.disabled = true
		modulate.a = 0.5
	# Apply the image to the texture rect
	usable_resource.resource_icon.texture = icon


func _process(_delta: float) -> void:
	if placing_resource and preview_resource:
		preview_resource.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if placing_resource and event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			preview_resource.global_position = get_global_mouse_position()
			placing_resource = false
			preview_resource.process_mode = Node.PROCESS_MODE_INHERIT
			preview_resource = null

func _on_button_pressed() -> void:
	print("Resource clicked! with cost = " + str(usable_resource.cost))
	
	preview_resource = resource_scene.instantiate() as Area2D
	# add it elsewhere ?
	add_child(preview_resource)
	preview_resource.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	placing_resource = true
