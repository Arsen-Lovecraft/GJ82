extends game_scene

func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	pause_menu.connect("pause_menu_reset", _on_reset_pressed)
	
func _on_reset_pressed() -> void:
	reload_self()

func reload_self() -> void:
	var parent := get_parent()
	var index := get_index()
	_scene_path = scene_file_path
	queue_free()
	var new_instance :Variant= load(_scene_path).instantiate()
	parent.add_child(new_instance)
	parent.move_child(new_instance, index)
