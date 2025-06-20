class_name Level
extends Node2D

var _settings_ps: PackedScene = preload("uid://ldg2jq7gg87x")

func _ready() -> void:
	_connect_signals()
	EventBus.level_started.emit()

func _connect_signals() -> void:
	self.tree_exiting.connect(_on_tree_exiting)

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().current_scene.add_child(_settings_ps.instantiate())

func _on_tree_exiting() -> void:
	EventBus.level_ended.emit()
