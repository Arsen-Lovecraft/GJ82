class_name MusicController
extends Node

var _music_settings: Music.MusicSettings

func _ready() -> void:
	_connect_signals()
	_init_easy_music_addon()

func _init_easy_music_addon() -> void:
	_music_settings = Music.MusicSettings.new()
	_music_settings.set_bus("Music")
	_music_settings.transition = Music.Transitions.CROSS_FADE
	print(AudioServer.get_bus_index("Music"))
	_music_settings.set_volume(db_to_linear(AudioServer.get_bus_volume_db(\
	AudioServer.get_bus_index("Music"))))
	
	_music_settings.set_duration(1.0)
	
func _connect_signals() -> void:
	EventBus.door_timer_started.connect(turn_on_intensive_theme_music)
	EventBus.door_timer_ended.connect(turn_on_theme_music)
	EventBus.level_started.connect(turn_on_theme_music)
	EventBus.level_ended.connect(_on_level_ended)

func turn_on_theme_music() -> void:
	_music_settings.set_path("uid://bejkf33em7w67")
	Music.play(_music_settings)

func turn_on_intensive_theme_music() -> void:
	_music_settings.set_path("uid://c34hdvpwqiq0u")
	Music.play(_music_settings)

func _on_level_ended() -> void:
	Music.stop()
