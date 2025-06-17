extends CharacterBody2D
class_name Player

signal gameOver

var echoScene : PackedScene = preload("uid://jpwvu7g48if4")

@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var echo_sound: AudioStreamPlayer = %echoSound
@onready var jump_sound: AudioStreamPlayer = %jumpSound


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
	pass

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
		##ECHO EMMISION
		_echo_emit(position,$echoPos.global_position)
	
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

## _physics_process END
	

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)


func _echo_emit(_playerPos: Vector2, echoPos: Vector2) -> void:
	var echo_emit := echoScene.instantiate()
	echo_emit.echoOrigin = echoPos
	add_child(echo_emit)
	
