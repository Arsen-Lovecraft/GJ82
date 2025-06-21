extends MovingStaticPlatform

func _move_platform() -> void:
	move_timer.wait_time = 3.0
	var switch : = _bot_pos
	_bot_pos = _top_pos
	_top_pos = switch
	
	var move_tween := create_tween()
	move_tween.tween_property(self,"position",_top_pos,move_timer.wait_time)
