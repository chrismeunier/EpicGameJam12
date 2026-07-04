extends TextureButton

@onready var label: Label = %Label

@export var id:int = 0

func _ready() -> void:
	label.text = "Level " + str(id+1)
