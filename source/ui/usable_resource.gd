class_name UsableResource
extends Control

var cost := 0

@onready var cost_text: Label = %CostText
@onready var resource_icon: TextureRect = %ResourceIcon

func _ready() -> void:
	pass
	#cost_text.text = "X " + str(cost)
