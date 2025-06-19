extends Node

signal _sonar_emitted(_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, angle_in_rad: float)
signal _sonar_scale(_scale: Vector2)

var fromMenuPause : bool = true :
	get():
		return fromMenuPause
	set(value):
		fromMenuPause = value
		
var generalPause : bool = true :
	get():
		return generalPause
	set(value):
		generalPause = value
