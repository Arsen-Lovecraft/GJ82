class_name Step
extends PointLight2D

##Scale = 1.0 is 15 px

var _vanish_time_scale: float = 1.0

@onready var _step_animation_player: AnimationPlayer = %StepAnimationPlayer

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_step_animation_player.animation_finished.connect(_on_animation_finished)

func emit_step(pos: Vector2, max_radius: float, min_radius: float, time_to_vanish:float) -> void:
	global_position = pos
	var max_scale: float = max_radius/15.0
	var min_scale: float = min_radius/15.0
	_step_animation_player.speed_scale = 1.0/time_to_vanish
	var scale: float = randf_range(min_scale, max_scale)
	_step_animation_player.get_animation("vanish").track_set_key_value(0,0,Vector2(scale,scale))
	_step_animation_player.play("vanish")

func _on_animation_finished(anim_name: String) -> void:
	if(anim_name == "vanish"):
		queue_free()
