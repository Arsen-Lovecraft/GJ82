extends Node
class_name MainGameTree
@onready var settings_menu: SettingsWindows = %settingsMenu
@onready var pause_menu: CanvasLayer = %pauseMenu


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pass
