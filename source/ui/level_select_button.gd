extends TextureButton

@onready var label: Label = %Label
@export var pictures: Array[Texture2D] = []

var _level: BaseLevel

func _on_pressed() -> void:
	Events.selected_level.emit(_level.level_id)

func setup(level: BaseLevel) -> void:
	_level = level
	label.text = _level.level_name + " " + str(_level.level_id)
	if _level.level_id > pictures.size():
		push_error("Add a picture for all levels")
	texture_normal = pictures[_level.level_id]
