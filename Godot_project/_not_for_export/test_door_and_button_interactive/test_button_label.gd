## It is not in-production code!
extends Label
@onready var _button: InteractiveButton = %Button

func _physics_process(_delta: float) -> void:
	if(_button._button_timer.is_stopped()):
		self.text = "Button is inactive"
	else:
		self.text = "Button is active"
