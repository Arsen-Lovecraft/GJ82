class_name EmergingPlatform
extends StaticBody2D

@export_range(0.1, 300) var seen_time: float = 4.0
@export var sonar_cone_deg: float = 30.00
@onready var collision_shape := $CollisionShape2D  # Or use get_node() to reach the Polygon2D
@onready var _seen_timer: Timer = %SeenTimer

var _emit_to_platform_verti_distances: Array
var _emit_to_platform_verti_angles: Array
var _emit_to_platform_angle_deg: float
var _platform_reveal_duration : float
var _reveal_time_speed_scale: float = 1.0
var _disappear_time_speed_scale:float = 1.0



func _ready() -> void:
	_init_platform()
	_connect_signals()

func _init_platform() -> void:
	#_disappear()
	pass
	
func _connect_signals() -> void:
	_seen_timer.timeout.connect(_disappear)
	EventBus.connect("_sonar_emitted",_on_sonar_emmission)

func _on_sonar_emmission (_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, disappear_time: float, angle_in_rad: float) -> void:
	#printt(_emit_position,size_relative_to_radius,reveal_time,disappear_time,angle_in_rad)
	_sonar_vs_platform_calculations(_emit_position, size_relative_to_radius, reveal_time, disappear_time, angle_in_rad)
	
	
	
func _sonar_vs_platform_calculations(_emit_position:Vector2, size_relative_to_radius:float, revealing_time: float, disappear_time: float, angle_in_rad: float) -> void:
	get_platform_global_data(_emit_position)
	angle_in_rad = angle_in_rad - PI/2
	var sonar_cone_rad := deg_to_rad(sonar_cone_deg)
	var angle_in_rad_right : float = angle_in_rad - sonar_cone_rad/2
	var angle_in_rad_left : float = angle_in_rad + sonar_cone_rad/2
	var max_sonar_size: float = size_relative_to_radius
	_seen_timer.wait_time = revealing_time + seen_time

	#if angle_in_rad_left >= _emit_to_platform_verti_angles[0] and angle_in_rad_left <= _emit_to_platform_verti_angles[1]:
		#_emerge()
	#elif angle_in_rad_left >= _emit_to_platform_verti_angles[1] and angle_in_rad_left <= _emit_to_platform_verti_angles[2]:
		#_emerge()
	#elif angle_in_rad_left >= _emit_to_platform_verti_angles[2] and angle_in_rad_left <= _emit_to_platform_verti_angles[3]:
		#_emerge()
	#elif angle_in_rad_left >= _emit_to_platform_verti_angles[3] and angle_in_rad_left <= _emit_to_platform_verti_angles[0]:
		#_emerge()
	#elif angle_in_rad_right >= _emit_to_platform_verti_angles[0] and angle_in_rad_right <= _emit_to_platform_verti_angles[1]:
		#_emerge()
	#elif angle_in_rad_right >= _emit_to_platform_verti_angles[1] and angle_in_rad_right <= _emit_to_platform_verti_angles[2]:
		#_emerge()
	#elif angle_in_rad_right >= _emit_to_platform_verti_angles[2] and angle_in_rad_right <= _emit_to_platform_verti_angles[3]:
		#_emerge()
	#elif angle_in_rad_right >= _emit_to_platform_verti_angles[3] and angle_in_rad_right <= _emit_to_platform_verti_angles[0]:
		#_emerge()
	#else:
		##pass
		#_disappear()
		
	## If the platform and echoPoint angle is between the angles made by both arms of the cone the emerge will trigger
	if ((angle_in_rad_right <= _emit_to_platform_verti_angles[0] and angle_in_rad_left >= _emit_to_platform_verti_angles[0]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[1] and angle_in_rad_left >= _emit_to_platform_verti_angles[1]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[2] and angle_in_rad_left >= _emit_to_platform_verti_angles[2]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[3] and angle_in_rad_left >= _emit_to_platform_verti_angles[3])) \
	and (max_sonar_size >= _emit_to_platform_verti_distances[0] or \
		max_sonar_size >= _emit_to_platform_verti_distances[1] or \
		max_sonar_size >= _emit_to_platform_verti_distances[2] or \
		max_sonar_size >= _emit_to_platform_verti_distances[3]):
		_emerge()
	elif ((angle_in_rad_right >= _emit_to_platform_verti_angles[0] and angle_in_rad_right <= _emit_to_platform_verti_angles[1]) or \
	(angle_in_rad_right >= _emit_to_platform_verti_angles[3] and angle_in_rad_right <= _emit_to_platform_verti_angles[2])):
		_emerge()
	else:
		_disappear()

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
	collision_shape.disabled = 0
	self.visible = 1
	_seen_timer.start()

func _disappear() -> void:
	collision_shape.disabled = 1
	self.visible = 0


	
