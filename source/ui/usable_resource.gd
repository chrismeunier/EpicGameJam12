class_name UsableResource
extends Control

@export var cost := 0

#@onready var icon : Texture2D
@onready var cost_text: Label = %CostText
@onready var resource_icon: TextureRect = %ResourceIcon

func _ready() -> void:
	#resource_icon.texture = icon
	cost_text.text = "X " + str(cost)
