class_name MovingStaticPlatform
extends StaticBody2D

@onready var bottom_marker: Marker2D = $bottom_marker
@onready var top_marker: Marker2D = $top_marker
@onready var move_timer: Timer = %moveTimer


@onready var _bot_pos: Vector2 = bottom_marker.global_position
@onready var _top_pos: Vector2 = top_marker.global_position

func _ready() -> void:
	_connect_signals()
	move_timer.wait_time = 0.1
	move_timer.start()
	
func _connect_signals() -> void:
	move_timer.connect("timeout",_move_platform)
	
func _move_platform() -> void:
	move_timer.wait_time = 5.0
	var switch : = _bot_pos
	_bot_pos = _top_pos
	_top_pos = switch
	
	var move_tween := create_tween()
	move_tween.tween_property(self,"position",_top_pos,move_timer.wait_time)
