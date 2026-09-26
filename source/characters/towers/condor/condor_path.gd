extends Path2D

@export var condor_scene: PackedScene
@export var spawn_probability: float = 1.0

var _is_condor_alive: bool = false

func _process(delta: float) -> void:
	if self.get_child_count() == 0:
		_is_condor_alive = false
	
	if not _is_condor_alive:
		if randf() < spawn_probability/1000.0:
			_is_condor_alive = true
			spawn_condor()

func spawn_condor() -> void:
	
	var c = condor_scene.instantiate()
	self.add_child(c)

	if c.has_method("setup"):
		c.setup(self, randf() > 0.5)
