extends Node

signal _sonar_emitted(_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, angle_in_rad: float)
signal _sonar_scale(_scale: Vector2)

signal door_timer_started()
signal door_timer_ended()
signal level_started()
signal level_ended()
