extends InteractiveDoor

func _ready() -> void:
	super()
	_door_animation_player.get_animation("door_open_light").loop_mode = Animation.LOOP_LINEAR
	open()

func open() -> void:
	super()
