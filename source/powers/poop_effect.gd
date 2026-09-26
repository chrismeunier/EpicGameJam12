extends Node2D

@onready var poop_impact: GPUParticles2D = %PoopImpact

func _ready() -> void:
	poop_impact.emitting = true
