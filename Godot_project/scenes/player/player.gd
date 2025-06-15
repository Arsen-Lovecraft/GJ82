extends CharacterBody2D
class_name Player

signal gameOver

@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var echo_sound: AudioStreamPlayer = %echoSound
@onready var jump_punch_sound: AudioStreamPlayer = %jumpPunchSound
@onready var jump_sound: AudioStreamPlayer = %jumpSound


@export var _player_data : RplayerData = preload("uid://byrd0re6gadg6")

var flipChar : bool = true
var playerDamage : float
var punching : bool = false
# used to store face on movement for animation
var face :float = 1.0
var shootFreq : bool = true
var anim_locked: bool = false
var SPEED : float
var JUMP_VELOCITY : float
var regen_rate : float 
var mp_regen_rate : float 
var now_regen : bool = true
var damage_taken : bool = false
var jumping : bool = false


var puncfreq : bool = true


func _ready() -> void:
	if(_player_data == null):
		printerr("Load player_data before adding to the tree: " + str(get_stack()))
	_connect_signals()
	add_to_group("Player")
	_init_data()

func _connect_signals()->void:
	_player_data.connect("dead", _on_dead)
	_player_data.connect("levelUp", _on_levelUp)
	for enemies in get_tree().get_nodes_in_group("enemies"):
		pass

func _init_data() -> void:
	playerDamage = _player_data.damage
	SPEED = _player_data.SPEED
	JUMP_VELOCITY = _player_data.JUMP_VELOCITY
	regen_rate = _player_data.regen_rate
	mp_regen_rate = _player_data.mp_regen_rate / _player_data.hp

func _on_body_entered(_body: Variant) -> void:
	pass
	
func _physics_process(delta: float) -> void:
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
		velocity.y = JUMP_VELOCITY
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
			velocity.x = direction * SPEED * delta
			face = direction
			if is_on_floor():
				play_animation("walk")
			elif velocity.y < 0.00:
				play_animation("jump")
			elif jumping:
				play_animation("jumpend")

			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				play_animation("idle")
			elif velocity.y < 0.00:
				play_animation("jump")
			elif jumping:
				play_animation("jumpend")

	
	if Input.is_action_just_pressed("primaryAction") and is_on_floor() and not anim_locked and puncfreq:
		anim_locked = true
		#echo
		anim_locked = false
		
	elif Input.is_action_just_pressed("primaryAction") and not is_on_floor() and not anim_locked and puncfreq:
		anim_locked = true
		#echo
		anim_locked = false

	
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

## _physics_process END
	
#_punchCooldown Connected on connectsignals
func _punchCooldown() -> void:
	puncfreq = true

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)

func damage_player(damage: float) -> void:
	_player_data.hp -= damage/_player_data.playerLevel
	damage_taken = true
	if _player_data.hp > 0:
		%damageSound.play()
		_player_data.mp += (_player_data.playerMprate * mp_regen_rate)/(_player_data.playerLevel * _player_data.hp)
		anim_locked = true
		play_animation("damage")
		await player_sprite.animation_finished
		anim_locked = false


func _on_dead()->void:
	anim_locked = true
	%deathSound.play()
	#%gameOverSound.play()

	play_animation("death")
	await player_sprite.animation_finished
	anim_locked = false
	queue_free()
	gameOver.emit()

func _on_levelUp() -> void:
	pass
	
func _regen() -> void:
	if not damage_taken:
		_player_data.hp += regen_rate
		_player_data.mp += mp_regen_rate

func _regenStart() -> void:
	damage_taken = false
