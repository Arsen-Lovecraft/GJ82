extends Node2D

const SETTINGS_UI = preload("res://scenes/settings/settings_ui.tscn")

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().current_scene.add_child(SETTINGS_UI.instantiate())
