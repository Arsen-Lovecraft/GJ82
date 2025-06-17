class_name InteractiveButton
extends Area2D

@export_range(0.0,100.0) var time_of_active_state: float = 5.0
@export var door: InteractiveDoor

@onready var _button_timer: Timer = %ButtonTimer
@onready var _click_button_sound: AudioStreamPlayer = %ClickButtonSound


func _ready() -> void:
	add_to_group("InteractiveButton")
	_init_interactive_button()
	_connect_signals()

func _init_interactive_button() -> void:
	if(door == null):
		printerr("Button does not have a door to reference to")
	_button_timer.wait_time = time_of_active_state

func _connect_signals() -> void:
	_button_timer.timeout.connect(_on_button_timer_timeout)

func activate_button() -> void:
	if(_button_timer.is_stopped()):
		door.open()
		_button_timer.start()

##AKA deactivate_button
func _on_button_timer_timeout() -> void:
	door.close()
