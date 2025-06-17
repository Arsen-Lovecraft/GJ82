extends Node2D
class_name echo

@onready var mat := preload("uid://cifiuepets4eq") as ShaderMaterial

func _ready()-> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var mouse_pos := get_viewport().get_mouse_position()
	var origin_uv := mouse_pos / viewport_size
	reveal_flashlight(origin_uv, Vector2.RIGHT, 0.0, 2000.0, 45.0, 1.5)

func reveal_flashlight(origin: Vector2, direction: Vector2, start_radius: float, end_radius: float, angle_deg: float, duration: float) -> void:
	# Convert origin to screen UV
	var screen_uv := origin
	mat.set_shader_parameter("reveal_origin", screen_uv)
	mat.set_shader_parameter("direction", direction.normalized())
	mat.set_shader_parameter("angle", angle_deg)

	var time := 0.0
	while time < duration:
		var r :Variant= lerp(start_radius, end_radius, time / duration)
		mat.set_shader_parameter("radius", r)
		#printt(r,time / duration)
		await get_tree().process_frame
		time += get_process_delta_time()
	mat.set_shader_parameter("radius", end_radius)
