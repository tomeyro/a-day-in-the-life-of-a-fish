extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	cpu_particles_2d.one_shot = true
	cpu_particles_2d.finished.connect(queue_free)
	cpu_particles_2d.emitting = true
