extends CharacterBody2D
class_name Player

signal gameOver

@export_group("Sonar")
@export var reveal_time: float = 1.0
@export var disappear_time: float = 1.0
@export var revealing_time: float = 1.0
@export var size_relative_to_radius: float = 500
@export_group("Other")

var _sonar_scene_ps: PackedScene = preload("uid://1yg762auekjc")

@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var echo_sound: AudioStreamPlayer = %echoSound
@onready var jump_sound: AudioStreamPlayer = %jumpSound
@onready var _echo_pos: Marker2D = %echoPos
@onready var _interaction_area: Area2D = %InteractionArea


@export var _player_data : RplayerData = preload("uid://byrd0re6gadg6")

var flipChar : bool = true
# used to store face on movement for animation
var face :float = 1.0
var anim_locked: bool = false
var speed : float
var jump_velocity : float
var jumping : bool = false


func _ready() -> void:
	if(_player_data == null):
		printerr("Load player_data before adding to the tree: " + str(get_stack()))
	_connect_signals()
	add_to_group("Player")
	_init_data()

func _connect_signals()->void:
	_interaction_area.area_entered.connect(_on_interaction_area_entered)

func _init_data() -> void:
	speed = _player_data.speed
	jump_velocity = _player_data.jump_velocity

func _on_body_entered(_body: Variant) -> void:
	pass

func _physics_process(delta: float) -> void:
	Global.PlayerPos = global_position
	
	# Add the gravity.
	if not is_on_floor():
		velocity += _player_data.gravity * delta

	#fall animation if player is not jumping and on air
	if !jumping and !is_on_floor():
		play_animation("fall")
	elif jumping and is_on_floor():
		jumping = false
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jumping = true
		jump_sound.play()

	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if face == 1.0:
		if not flipChar:
			player_sprite.flip_h = 0
			player_collision.position.x *= -1
			flipChar = true
			

	elif face == -1.0:
		if flipChar:
			player_sprite.flip_h = 1
			player_collision.position.x *= -1
			flipChar = false
			
	if not anim_locked:
		if direction:
			velocity.x = direction * speed * delta
			face = direction
			if is_on_floor():
				play_animation("walk")
			elif velocity.y < 0.00:
				play_animation("jump")
			elif jumping:
				play_animation("jumpend")

			
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor():
				play_animation("idle")
			elif velocity.y < 0.00:
				play_animation("jump")
			elif jumping:
				play_animation("jumpend")	
	
	if Input.is_action_just_pressed("sonar"):
		var sonar: Sonar = _sonar_scene_ps.instantiate()
		get_tree().current_scene.add_child(sonar)
		sonar.set_sonar_parametres(reveal_time,disappear_time,revealing_time,size_relative_to_radius)
		sonar.emit_sonar(_echo_pos.global_position, _echo_pos.get_angle_to(get_global_mouse_position()) + PI/2 )
	if(Input.is_action_just_pressed("interact")):
		_try_to_activate_button()
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
## _physics_process END

func _try_to_activate_button() -> void:
	for i: Area2D in _interaction_area.get_overlapping_areas():
		if(i is InteractiveButton):
			(i as InteractiveButton).activate_button()

func _on_interaction_area_entered(area: Area2D) -> void:
	if(area is InteractiveDoor):
		SceneManager.load_scene((area as InteractiveDoor).level_to_load)

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)
