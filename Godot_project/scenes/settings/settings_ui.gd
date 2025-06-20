class_name SettingsWindows
extends CanvasLayer

@onready var _game: GameSettingsUI = %GAME
@onready var _exit_button: Button = %ExitButton
var _prev_mouse_capture_mode: Input.MouseMode

func _ready() -> void:
	_connect_signals()
	_prev_mouse_capture_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _connect_signals() -> void:
	if _exit_button.pressed.connect(_on_pressed_exited): printerr("Fail: ",get_stack())
	if _game.game_continued.connect(_on_continued_pressed): printerr("Fail: ",get_stack())

func _on_continued_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_capture_mode
	queue_free()

func _on_pressed_exited() -> void:
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_capture_mode
	get_tree().quit(0)
	queue_free()
