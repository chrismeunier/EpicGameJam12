extends Path2D

@export var condor_scene: PackedScene
@export var spawn_probability: float = 1.0
@export var condor_blanking_time: float = 5.0

var _is_condor_alive: bool = false
var _no_condor_since: float = 0.0

func _process(delta: float) -> void:
	if _is_condor_alive && self.get_child_count() == 0:
		_is_condor_alive = false
		_no_condor_since = 0.0
	
	if _is_condor_alive:
		return
	
	_no_condor_since += delta
	
	if _no_condor_since >= condor_blanking_time:
		if not _is_condor_alive:
			if randf()*1000 < spawn_probability:
				_is_condor_alive = true
				spawn_condor()

func spawn_condor() -> void:
	
	var c = condor_scene.instantiate()
	self.add_child(c)

	if c.has_method("setup"):
		c.setup(self, randf() > 0.5)
