class_name EmergingPlatform
extends StaticBody2D

@export_range(0.1, 300) var seen_time: float = 2.0
@export var sonar_cone_deg: float = 30.00
@onready var collision_shape := $CollisionShape2D  # Or use get_node() to reach the Polygon2D
@onready var _seen_timer: Timer = %SeenTimer
@onready var platform_emerge: AudioStreamPlayer2D = %platformEmerge
@onready var platform_disapper: AudioStreamPlayer2D = %platformDisapper
@onready var platform_stays: AudioStreamPlayer2D = %platformStays
@onready var plat_texture: Sprite2D = %platTexture


var _emit_to_platform_verti_distances: Array
var _emit_to_platform_verti_angles: Array
var _sonar_scale : Vector2
var _emerge_success: bool = false
var _emerging_sound: bool = false
var _emerged_sound: bool = false
var _emerge_success_sonar : bool = false
var _disappeared := false



func _ready() -> void:
	_init_platform()
	_connect_signals()

func _init_platform() -> void:
	plat_texture.self_modulate.a = 0
	collision_shape.disabled = 1
	
func _connect_signals() -> void:
	if not _seen_timer.timeout.is_connected(_timer_stopped):
		_seen_timer.timeout.connect(_timer_stopped)
	EventBus.connect("_sonar_emitted",_on_sonar_emmission)
	EventBus.connect("_sonar_scale", _sonar_scale_every_frame)

func _on_sonar_emmission (_emit_position:Vector2, size_relative_to_radius:float, reveal_time: float, angle_in_rad: float) -> void:
	#printt(_emit_position,size_relative_to_radius,reveal_time,disappear_time,angle_in_rad)
	_sonar_vs_platform_calculations(_emit_position, size_relative_to_radius, reveal_time, angle_in_rad)
	
	
func _sonar_vs_platform_calculations(_emit_position:Vector2, size_relative_to_radius:float, revealing_time: float, angle_in_rad: float) -> void:
	get_platform_global_data(_emit_position)
	angle_in_rad = angle_in_rad - PI/2
	var sonar_cone_rad := deg_to_rad(sonar_cone_deg)
	var angle_in_rad_right : float = angle_in_rad - sonar_cone_rad/2
	var angle_in_rad_left : float = angle_in_rad + sonar_cone_rad/2
	var max_sonar_size: float = size_relative_to_radius
	# Adding so that revealing time if changed no need to change seen_time
	_seen_timer.wait_time = revealing_time + seen_time


	## If the platform and echoPoint angle is between the angles made by both arms of the cone the emerge will trigger
	if ((angle_in_rad_right <= _emit_to_platform_verti_angles[0] and angle_in_rad_left >= _emit_to_platform_verti_angles[0]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[1] and angle_in_rad_left >= _emit_to_platform_verti_angles[1]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[2] and angle_in_rad_left >= _emit_to_platform_verti_angles[2]) or \
	(angle_in_rad_right <= _emit_to_platform_verti_angles[3] and angle_in_rad_left >= _emit_to_platform_verti_angles[3])) \
	and (max_sonar_size >= _emit_to_platform_verti_distances[0] or max_sonar_size >= _emit_to_platform_verti_distances[1] or \
	max_sonar_size >= _emit_to_platform_verti_distances[2] or max_sonar_size >= _emit_to_platform_verti_distances[3]):
		_emerge_success = true
		
	elif ((angle_in_rad_right >= _emit_to_platform_verti_angles[0] and angle_in_rad_right <= _emit_to_platform_verti_angles[1]) or \
	(angle_in_rad_right >= _emit_to_platform_verti_angles[3] and angle_in_rad_right <= _emit_to_platform_verti_angles[2])):
		_emerge_success = true
		
	else:
		_emerge_success = false

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

func _sonar_scale_every_frame(sonar_scale: Vector2) -> void:
	_sonar_scale = sonar_scale * 205.0
	if ((_sonar_scale.x >= _emit_to_platform_verti_distances[0] or _sonar_scale.x >= _emit_to_platform_verti_distances[1] or \
_sonar_scale.x >= _emit_to_platform_verti_distances[2] or _sonar_scale.x >= _emit_to_platform_verti_distances[3])) and _emerge_success:
		_emerge()
		_emerge_success_sonar = true

func _process(_delta: float) -> void:
	if _emerging_sound and _emerge_success and !_emerged_sound:
		platform_emerge.play()
		platform_emerge.seek(0.10)
		_emerging_sound = false
		_emerged_sound = true
	if !platform_emerge.playing and !platform_stays.playing and !platform_disapper.playing and _emerge_success and _emerged_sound:
		platform_stays.play()
		platform_emerge.seek(0.26)

func _emerge() -> void:
	_disappeared = false
	_emerging_sound = true
	collision_shape.disabled = 0
	plat_texture.self_modulate.a = 1.0
	if _seen_timer.is_stopped():
		_seen_timer.start()
		


func _disappear() -> void:
	if _disappeared:
		return
	_disappeared = true
	platform_disapper.play()
	var _vis_tween : = create_tween()
	_vis_tween.tween_property(plat_texture,"self_modulate:a",0.0,1).from(1.0)
	collision_shape.disabled = 1
	_emerging_sound = false
	_emerge_success = false
	_emerged_sound = false
	_emerge_success_sonar = false

func _timer_stopped() -> void:
	_disappear()
