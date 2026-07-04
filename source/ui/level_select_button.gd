extends TextureButton

@onready var label: Label = %Label

var level: BaseLevel
var id:int = 0

func _ready() -> void:
	id = level.level_id
	label.text = level.level_name


func _on_pressed() -> void:
	Events.selected_level.emit(id)
