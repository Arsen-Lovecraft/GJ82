class_name InteractiveButton
extends Area2D

@export_range(0.0,100.0) var time_of_active_state: float = 5.0
@export var door: InteractiveDoor
@export var button: InteractiveButton

@onready var _button_timer: Timer = %ButtonTimer
@onready var _click_button_sound: AudioStreamPlayer = %ClickButtonSound
@onready var _button_tick_sound: AudioStreamPlayer2D = %ButtonTick
@onready var _light_animation_player: AnimationPlayer = %LightAnimationPlayer


func _ready() -> void:
	add_to_group("InteractiveButton")
	if button != null:
		button.close()
	_init_interactive_button()
	_connect_signals()

func _init_interactive_button() -> void:
	if(door == null and button != null):
		printerr("this is a button to activate button")
	_button_timer.wait_time = time_of_active_state
	_button_tick_sound.play()
	_light_animation_player.play("light_scale_up_scale_down")

func _connect_signals() -> void:
	_button_timer.timeout.connect(_on_button_timer_timeout)
	_button_tick_sound.finished.connect(_on_ticking_finished)

func activate_button() -> void:
	if(_button_timer.is_stopped()):
		_button_tick_sound.stop()
		_click_button_sound.play()
		if(door == null and button != null):
			button.open()
			close()
		else:
			door.open()
			EventBus.door_timer_started.emit()
		_button_timer.start()
		

func open() -> void:
	self.monitorable = true
	self.visible = true
	self.monitoring = true
	
func close() -> void:
	self.monitorable = false
	self.visible = false
	self.monitoring = false
	
##AKA deactivate_button
func _on_button_timer_timeout() -> void:
	if(door == null and button != null):
		button.close()
		open()
	else:
		door.close()
		EventBus.door_timer_ended.emit()
	_light_animation_player.play("light_scale_up_scale_down")
	_button_tick_sound.play()
	
func _on_ticking_finished() -> void:
	#emit point2dLight here
	_light_animation_player.play("light_scale_up_scale_down")
	_button_tick_sound.play()

##To activate another button with the button
func _door_button_activate() -> void:
	button.monitorable = false
	button.visible = false
