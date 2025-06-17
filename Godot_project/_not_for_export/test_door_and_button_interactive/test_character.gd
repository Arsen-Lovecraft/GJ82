## It is not in-production code!
extends CharacterBody2D

@onready var _interaction_area: Area2D = %InteractionArea

func _ready() -> void:
	_interaction_area.area_entered.connect(_on_area_entered)

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 25000.0 * _delta
	move_and_slide()
	if(Input.is_action_just_pressed("interact")):
		_try_to_activate_button()

func _try_to_activate_button() -> void:
	for i: Area2D in _interaction_area.get_overlapping_areas():
		if(i is InteractiveButton):
			(i as InteractiveButton).activate_button()

func _on_area_entered(area: Area2D) -> void:
	if(area is InteractiveDoor):
		SceneManager.load_scene((area as InteractiveDoor).level_to_load)
		
