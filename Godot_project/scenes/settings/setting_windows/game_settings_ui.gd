class_name GameSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _options_settings_ui: OptionsSettingsUI = %OptionsSettingsUi
@onready var start_game: Button = %StartGame
@onready var end_game: Button = %EndGame


func _ready() -> void:
	_connect_signals()
	_init_languages_list()
	if(Global.scenes_layout.last_scene != "uid://ldg2jq7gg87x" and Global.scenes_layout.last_scene != ""):
		start_game.text = "CONTINUE"

func _connect_signals() -> void:
	if _options_settings_ui.new_value_selected.connect(_on_language_selected): printerr("Fail: ",get_stack()) 
	start_game.connect("pressed",_on_start_game)
	end_game.connect("pressed",_on_end_game)

func _init_languages_list() -> void:
	_options_settings_ui.init_option_button(settings.LANGUAGES.keys(), settings.LANGUAGES.find_key(settings.language) as String)

func _on_language_selected(value: String) -> void:
	settings.set_language(settings.LANGUAGES[value])

##If last scene is menu then you loads level_1
func _on_start_game() -> void:
	if(Global.scenes_layout.last_scene != "uid://ldg2jq7gg87x" and Global.scenes_layout.last_scene != ""):
		SceneManager.load_scene(Global.scenes_layout.last_scene)
	else:
		SceneManager.load_scene("uid://cra0887wqyq40")
	
func _on_end_game() -> void:
	get_tree().quit()
