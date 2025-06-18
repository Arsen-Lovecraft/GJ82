class_name EmergingPlatform
extends StaticBody2D

@export_range(0.1, 300) var seen_time: float = 4.0
@onready var collision_shape := $CollisionShape2D  # Or use get_node() to reach the Polygon2D

var _emit_to_platform_verti_distances: Array
var _emit_to_platform_verti_angles: Array
var _emit_to_platform_angle_deg: float
var _platform_reveal_duration : float
var _reveal_time_speed_scale: float = 1.0
var _disappear_time_speed_scale:float = 1.0


@onready var _seen_timer: Timer = %SeenTimer

func _ready() -> void:
	_init_platform()
	_connect_signals()
	

func _init_platform() -> void:
	_seen_timer.wait_time = seen_time
	
func _connect_signals() -> void:
	_seen_timer.timeout.connect(_on_seen_timer_timeout)
	EventBus.connect("_sonar_emitted",_on_sonar_emmission)

func _on_sonar_emmission (_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, disappear_time: float, angle_in_rad: float) -> void:
	#printt(_emit_position,size_relative_to_radius,reveal_time,disappear_time,angle_in_rad)
	_sonar_vs_platform_calculations(_emit_position, size_relative_to_radius, reveal_time, disappear_time, angle_in_rad)
	_reveal_time_speed_scale = 1.0/reveal_time
	_disappear_time_speed_scale = 1.0/disappear_time
	printt(_emit_to_platform_verti_distances, _emit_to_platform_verti_angles, \
	_reveal_time_speed_scale, _disappear_time_speed_scale)
	
	
func _sonar_vs_platform_calculations(_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, disappear_time: float, angle_in_rad: float) -> void:
	get_platform_global_data(_emit_position)
	
	
func get_platform_global_data(_emit_position: Vector2) -> void:
	var shape := collision_shape.shape as RectangleShape2D
	var extents :Variant= shape.extents
	var local_points := [
		Vector2(-extents.x, -extents.y), #TopLeft
		Vector2(extents.x, -extents.y),  #TopRight
		Vector2(extents.x, extents.y),   #BottomRight
		Vector2(-extents.x, extents.y),  #BottomLeft
	]
	_emit_to_platform_verti_distances = []
	_emit_to_platform_verti_angles = []
	for p:Variant in local_points:
		_emit_to_platform_verti_distances.append(_emit_position.distance_to(collision_shape.to_global(p)))
		_emit_to_platform_verti_angles.append(_emit_position.angle_to_point(collision_shape.to_global(p)))



func _emerge() -> void:
	if(_seen_timer.is_stopped()):
		_seen_timer.start()
		self.collision_layer = 1

func _on_seen_timer_timeout() -> void:
	self.collision_layer = 0
