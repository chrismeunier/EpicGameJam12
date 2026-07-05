class_name LevelSelectButton
extends TextureButton

@export var pictures: Array[Texture2D] = []

@onready var label: Label = %Label
@onready var succeeded: TextureRect = %Succeeded
@onready var completion_label: Label = %CompletionLabel

var _level: BaseLevel

func _on_pressed() -> void:
	Events.selected_level.emit(_level.level_id)

func setup(level: BaseLevel) -> void:
	_level = level
	label.text = _level.level_name
	if _level.level_id > pictures.size():
		push_error("Add a picture for all levels")
	texture_normal = pictures[_level.level_id]
	update_success()

func update_success(success: bool = false, percentage: int = 0):
	if success:
		succeeded.show()
	else:
		succeeded.hide()
	completion_label.text = str(percentage) + "%"
