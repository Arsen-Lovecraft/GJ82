@tool
class_name StaticEnvironment
extends StaticBody2D

@export var amount_of_particles: int = 800:
	set(value):
		amount_of_particles = value
		if(_cpu_particles_2d != null):
			_cpu_particles_2d.amount = amount_of_particles

@onready var _cpu_particles_2d: CPUParticles2D = %CPUParticles2D

func _ready() -> void:
	_cpu_particles_2d.amount = amount_of_particles
