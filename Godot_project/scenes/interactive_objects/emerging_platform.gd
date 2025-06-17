class_name EmergingPlatform
extends StaticBody2D

@export_range(0.1, 300) var seen_time: float = 4.0

@onready var _seen_timer: Timer = %SeenTimer

func _ready() -> void:
	_init_platform()
	_connect_signals()

func _init_platform() -> void:
	_seen_timer.wait_time = seen_time

func _connect_signals() -> void:
	_seen_timer.timeout.connect(_on_seen_timer_timeout)

func _emerge() -> void:
	if(_seen_timer.is_stopped()):
		_seen_timer.start()
		self.collision_layer = 1

func _on_seen_timer_timeout() -> void:
	self.collision_layer = 0
