class_name Sonar
extends PointLight2D


@onready var _sonar_animation_player: AnimationPlayer = %SonarAnimationPlayer
@onready var _revealing_timer: Timer = %RevealingTimer
@onready var _sonar_sfx_stream_player: AudioStreamPlayer = %SonarSFXStreamPlayer
@onready var _cooldown_timer: Timer = %cooldownTimer

var _revealing_time: float = 1.0
var _reveal_time_speed_scale: float = 1.0
var _disappear_time_speed_scale:float = 1.0
#1.0 is 205.0 radius -> so 2.0 would be 410.0
var _default_radius: float = 1.0

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_sonar_animation_player.animation_finished.connect(_on_animation_finished)
	_revealing_timer.timeout.connect(_on_reveling_timer_timeout)

func emit_sonar(pos: Vector2, angle: float) -> void:
	global_position = pos
	global_rotation = angle
	_sonar_animation_player.play("reveal")
	_sonar_sfx_stream_player.play()

func set_sonar_parametres(reveal_time: float, disappear_time: float, \
revealing_time: float = 1.0, size_relative_to_radius: float = 80.0) -> void:
	_revealing_timer.wait_time = revealing_time
	_reveal_time_speed_scale = 1.0/reveal_time
	_disappear_time_speed_scale = 1.0/disappear_time
	var max_sonar_size: float = size_relative_to_radius / 205.0
	_sonar_animation_player.get_animation("disappear").track_set_key_value(0,0,Vector2(max_sonar_size,max_sonar_size))
	_sonar_animation_player.get_animation("reveal").track_set_key_value(0,1,Vector2(max_sonar_size,max_sonar_size))

func _on_animation_finished(anim_name: String) -> void:
	if(anim_name == "reveal"):
		_sonar_animation_player.speed_scale = _reveal_time_speed_scale
		_revealing_timer.start()
	elif(anim_name == "disappear"):
		queue_free()

func _on_reveling_timer_timeout() -> void:
	_sonar_animation_player.speed_scale = _disappear_time_speed_scale
	_sonar_animation_player.play("disappear")

func _process(_delta: float) -> void:
	EventBus._sonar_scale.emit(scale)
	
