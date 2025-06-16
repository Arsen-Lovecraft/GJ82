extends Node2D
class_name echo_location

#@onready var sprite := $Sprite2D
@onready var mat := preload("uid://cifiuepets4eq") as ShaderMaterial
@onready var viewport_size := get_viewport().get_visible_rect().size
@onready var echo_timer: Timer = %echoTimer

@export var pulse_time := 0.0
@export var pulse_duration := 3          # Seconds for full pulse
@export var min_radius := 0.0
@export var max_radius := 600.0
@export var softness := 30.0
@export var cone_angle := 30.0             # Half angle of cone
@export var echoOrigin : Vector2

var reverseEcho : bool = false

func _ready() -> void:
	max_radius = max(get_viewport_rect().size.x ,get_viewport_rect().size.y) * 2
	# For reverse direction: point away from screen center
	#var center := viewport_size / 2.0
	#var direction := (get_viewport().get_mouse_position() - center).normalized()
	var direction := (get_viewport().get_mouse_position() - Global.PlayerPos).normalized()
	mat.set_shader_parameter("direction", direction)
	echo_timer.start()
	_connect_signals()
	
func _connect_signals() -> void:
	echo_timer.connect("timeout",_echo_timeout)

func _echo_timeout() -> void:
	reverseEcho = 1


	

func _process(delta: float) -> void:
	pulse_time += delta
	if reverseEcho:
		mat.set_shader_parameter("hide", 1.0)
	else:
		mat.set_shader_parameter("hide", 1.0)
	
	# Animate the radius
	var radius :Variant= lerp(min_radius, max_radius, pulse_time/pulse_duration)
	radius = clampf(radius, min_radius, max_radius)
	mat.set_shader_parameter("radius", radius)
	mat.set_shader_parameter("softness", softness)
	mat.set_shader_parameter("angle", cone_angle)
	
	#printt(radius, pulse_time/pulse_duration)
	
	# Get the mouse position and convert to UV
	
	#mouse_pos = get_viewport().get_mouse_position() - Vector2(20.0, 20.0)
	#mouse_pos = Vector2(0.5,0.5) - Vector2(20.0, 20.0)
	var origin_uv := echoOrigin / viewport_size
	#printt(origin_uv, viewport_size, mouse_pos)

	mat.set_shader_parameter("reveal_origin", origin_uv)
