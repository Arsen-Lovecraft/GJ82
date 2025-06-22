@tool
class_name StaticEnvironment
extends StaticBody2D

@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@export var occluder_switch : bool = true

@export var amount_of_particles: int = 800:
	set(value):
		amount_of_particles = value
		if(_cpu_particles_2d != null):
			_cpu_particles_2d.amount = amount_of_particles

@onready var _cpu_particles_2d: CPUParticles2D = %CPUParticles2D

func _ready() -> void:
	_cpu_particles_2d.amount = amount_of_particles
	light_occluder_2d.visible = occluder_switch
