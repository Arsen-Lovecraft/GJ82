class_name RScenesLayout
extends Resource


@export var menu: String
@export_storage var last_scene: String = ""


func _init() -> void:
	if(last_scene == ""):
		last_scene = menu
