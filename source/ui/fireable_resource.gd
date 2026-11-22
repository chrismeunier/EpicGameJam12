class_name FireableResource
extends ClickableResource

signal fired(instance: Node)

var _initial_cost : int = 0

func _ready() -> void:
	super._ready()
	_initial_cost = cost
	#condor specific logic
	Events.condor_entered.connect(_enable_with_condor)
	Events.condor_exited.connect(_disable_without_condor)

# Condor specific enable/disable
func _disable_without_condor():
	cost = int(INF)
	refresh_availability(false)
func _enable_with_condor():
	cost = _initial_cost
	#TODO: test money and enable if ok

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if shortcut_key != KEY_NONE and event.keycode == shortcut_key:
			_on_button_pressed()

func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	# Don't fire while another resource is being placed
	if not available or already_selected:
		return

	Events.bought_resource.emit(cost)

	var instance: Node = null
	if resource_scene:
		instance = resource_scene.instantiate()
		var target: Node = parent_node_for_placing
		if target == null:
			target = get_tree().current_scene
		# Get the condor position through the CondorPath
		for child in target.get_children():
			if child is CondorPath: 
				if child.has_condor():
					instance.global_position = child.get_condor_position()
					# link the signals to stop and remove the condor
					instance.ready.connect(child.stop_condor)
					instance.animation_ended.connect(child.remove_condor)
				else:
					# Do not do anything if there is no condor
					return
		target.add_child(instance)
		
		if instance.has_method("start_audio"):
			instance.start_audio()
		if instance.has_method("fire"):
			instance.fire()

	fired.emit(instance)
