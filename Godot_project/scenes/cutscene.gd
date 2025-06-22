class_name Cutscene
extends CanvasLayer

@onready var _video_stream_player: VideoStreamPlayer = %VideoStreamPlayer
@onready var _skip_button: Button = %SkipButton
@onready var _skip_timer: Timer = %SkipTimer
@onready var _focus_button: TextureButton = %FocusButton

func _ready() -> void:
	_connect_signals()
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if(!_skip_timer.is_stopped()):
		_skip_button.text = str(int(_skip_timer.time_left))

func _connect_signals() -> void:
	_focus_button.pressed.connect(_on_focused)
	_video_stream_player.finished.connect(_on_cutscene_finished)
	_skip_button.button_up.connect(_on_skip_button_upped)
	_skip_button.button_down.connect(_on_skip_button_downed)
	_skip_timer.timeout.connect(_on_skipped)

func _on_focused() -> void:
	get_tree().paused = false
	_focus_button.get_parent().queue_free()

func _on_cutscene_finished() -> void:
	SceneManager.load_scene(Global.scenes_layout.menu)

func _on_skip_button_upped() -> void:
	_skip_button.text = ">>>>"
	_skip_timer.stop()

func _on_skip_button_downed() -> void:
	_skip_timer.start()

func _on_skipped() -> void:
	_skip_button.visible = false
	SceneManager.load_scene(Global.scenes_layout.menu)
