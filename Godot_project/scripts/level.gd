class_name Level
extends Node2D

var _settings_ps: PackedScene = preload("uid://ldg2jq7gg87x")


func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().current_scene.add_child(_settings_ps.instantiate())
	
