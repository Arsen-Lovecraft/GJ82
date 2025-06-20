class_name WinSceneCanvas
extends CanvasLayer

@onready var _menu_load: Button = %MenuLoad

func _ready() -> void:
	_connect_singals()
	Global.scenes_layout.last_scene = "uid://ldg2jq7gg87x"

func _connect_singals() -> void:
	_menu_load.pressed.connect(_on_lod_to_menu_pressed)

func _on_lod_to_menu_pressed() -> void:
	SceneManager.load_scene(Global.scenes_layout.menu)
