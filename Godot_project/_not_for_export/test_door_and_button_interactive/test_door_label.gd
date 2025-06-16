## It is not in-production code!
extends Label

@onready var _interactive_door: InteractiveDoor = %InteractiveDoor

func _physics_process(_delta: float) -> void:
	if(_interactive_door.monitorable == true):
		self.text = "Door is opened"
	else:
		self.text = "Door is closed"
