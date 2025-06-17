extends Node
class_name MainGameTree
@onready var settings_menu: SettingsWindows = %settingsMenu
#@onready var pause_menu: CanvasLayer = %pauseMenu


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and !EventBus.fromMenuPause:
		EventBus.generalPause = !EventBus.generalPause

	## Serialization matters here
	get_tree().paused = EventBus.fromMenuPause
	get_tree().paused = EventBus.generalPause
