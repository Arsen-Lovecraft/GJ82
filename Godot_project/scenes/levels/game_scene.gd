extends Node
class_name game_scene

var _scene_path: String
@onready var pause_menu: pauseMenu = %pauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	pause_menu.connect("pause_menu_reset",_on_reset_press)

func _on_reset_press() -> void:
	reload_self()
	print("relaod")
	
func reload_self() -> void:
	var parent := get_parent()
	var index := get_index()
	queue_free()
	var new_instance :Variant= load(_scene_path).instantiate()
	parent.add_child(new_instance)
	parent.move_child(new_instance, index)
