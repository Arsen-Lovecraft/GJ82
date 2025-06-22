class_name GameSettingsUI
extends Control

signal game_continued()

@onready var settings: RSettings = Global.settings
@onready var _options_settings_ui: OptionsSettingsUI = %OptionsSettingsUi
@onready var start_game: Button = %StartGame
@onready var end_game: Button = %EndGame
@onready var go_to_start: Button = %GoToStart
@onready var credits: RichTextLabel = %Credits


func _ready() -> void:
	_connect_signals()
	_init_languages_list()
	if(Global.scenes_layout.last_scene != "uid://ldg2jq7gg87x" and Global.scenes_layout.last_scene != "" or \
	get_tree().current_scene is Level):
		start_game.text = "CONTINUE"

func _process(_delta: float) -> void:
	credits.text = "[color=blue][b]Arsen Lovecraft[/b][/color] 	- "+tr("Game Designer")+"[i] and [/i]"+tr("Programmer")+"
[color=green][b]Kalineo[/b][/color]       	- "+tr("Programmer")+"[i] and [/i]"+tr("Game Designer")+"
[color=blue][b]RaisinRiot[/b][/color]      	- "+tr("Music Composer")+"[i] and [/i]"+tr("Sound Designer")+"
[color=green][b]Jebus Crust[/b][/color]     	- "+tr("Artist")+" [i] and [/i] "+tr("Animator")+""

func _connect_signals() -> void:
	if _options_settings_ui.new_value_selected.connect(_on_language_selected): printerr("Fail: ",get_stack()) 
	start_game.connect("pressed",_on_start_game)
	end_game.connect("pressed",_on_end_game)
	go_to_start.connect("pressed",_on_goto_start)

func _init_languages_list() -> void:
	_options_settings_ui.init_option_button(settings.LANGUAGES.keys(), settings.LANGUAGES.find_key(settings.language) as String)

func _on_language_selected(value: String) -> void:
	settings.set_language(settings.LANGUAGES[value])

##If last scene is menu then you loads level_1
func _on_start_game() -> void:
	if(get_tree().current_scene is Level):
		game_continued.emit()
		return
	##If last scene is menu then you loads level_1
	if(Global.scenes_layout.last_scene != Global.scenes_layout.menu and Global.scenes_layout.last_scene != ""):
		SceneManager.load_scene(Global.scenes_layout.last_scene)
	else:
		SceneManager.load_scene(Global.scenes_layout.first_level)
	
func _on_end_game() -> void:
	get_tree().quit()

func _on_goto_start() ->void:
	Global.scenes_layout.last_scene = "uid://ldg2jq7gg87x"
	SceneManager.load_scene(Global.scenes_layout.last_scene)
