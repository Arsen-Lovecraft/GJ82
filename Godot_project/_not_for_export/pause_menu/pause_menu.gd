extends CanvasLayer
class_name pauseMenu

signal pause_menu_reset()

@onready var reset: Button = %reset
@onready var play: Button = %play
@onready var menu: Button = %menu

var current_scene_packed: PackedScene
var current_scene_path: String

func _ready() -> void:
	connect_signals()
	
func _process(_delta: float) -> void:
	# this will pause the scene automatically when pause is visible
	if EventBus.generalPause and !EventBus.fromMenuPause:
		visible = true
	else:
		visible = false
	
func connect_signals() -> void:
	reset.connect("pressed",_on_reset_press)
	play.connect("pressed",_on_play_press)
	menu.connect("pressed",_on_menu_press)
	
func _on_reset_press() -> void:
	pause_menu_reset.emit()
	EventBus.generalPause = false
	EventBus.fromMenuPause = false

	
func _on_play_press() -> void:
	EventBus.generalPause = !EventBus.generalPause
	
func _on_menu_press() -> void:
	EventBus.fromMenuPause = true
	EventBus.generalPause = true
