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

var _reverseEcho : bool = false
var _fade : float = 1.0
var _radius : float 

func _ready() -> void:
	max_radius = max(get_viewport_rect().size.x ,get_viewport_rect().size.y) * 2

	var direction := (get_viewport().get_mouse_position() - Global.PlayerPos).normalized()
	mat.set_shader_parameter("direction", direction)
	echo_timer.stop()
	echo_timer.start()
	_connect_signals()
	
func _connect_signals() -> void:
	echo_timer.connect("timeout",_echo_timeout)

func _echo_timeout() -> void:
	_reverseEcho = 1
	

func _process(delta: float) -> void:
	pulse_time += delta
	if _reverseEcho:
		_fade -= delta
		mat.set_shader_parameter("fade", _fade)
		if _fade <= 0.0:
			echo_timer.stop()
			queue_free()
		
	else: 
		_radius = lerp(min_radius, max_radius, pulse_time/pulse_duration)
		mat.set_shader_parameter("fade", _fade)
		
	# Animate the radius
	
	_radius = clampf(_radius, min_radius, max_radius)
	mat.set_shader_parameter("radius", _radius)
	mat.set_shader_parameter("softness", softness)
	mat.set_shader_parameter("angle", cone_angle)
	
	#printt(radius, pulse_time/pulse_duration)

	var origin_uv := echoOrigin / viewport_size


	mat.set_shader_parameter("reveal_origin", origin_uv)
