extends CharacterBody2D
class_name Player

signal gameOver

@export_group("Sonar")
@export_range(0.1,20) var reveal_time: float = 1.0
@export_range(0.1,20) var disappear_time: float = 1.0
@export_range(0.1,1000) var revealing_time: float = 1.0
@export_range(10,1000) var size_relative_to_radius: float = 500
@export_group("Steps")
@export_range(0.5,20) var emit_capacity: int = 12.0
@export_range(0,200) var max_size: float = 180.0
@export_range(0,100) var min_size: float = 100.0
@export_range(0.1,20) var time_to_vanish: float = 0.7
@export_range(0,2) var emit_cooldown: float = 0.075
@export_range(1,15) var emit_count_on_landing: int = 12
@export_group("Other")

var _sonar_scene_ps: PackedScene = preload("uid://1yg762auekjc")
var _step_scene_ps: PackedScene = preload("uid://boxukbufy1aj7")
var _steps_pool: Array[Step]

@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var jump_sound: AudioStreamPlayer = %jumpSound
@onready var _echo_pos: Marker2D = %echoPos
@onready var _interaction_area: Area2D = %InteractionArea
@onready var _steps_emitter_cooldown: Timer = %StepsEmitterCooldown
@onready var _sonar_cooldown: Timer = %sonarCooldown
@onready var _step_player: AudioStreamPlayer = %StepPlayer
@onready var _collide_with_walls_roofs_player: AudioStreamPlayer = %CollideWithWallsRoofsPlayer


@export var _player_data : RplayerData = preload("uid://byrd0re6gadg6")

var flipChar : bool = true
# used to store face on movement for animation
var face :float = 1.0
var anim_locked: bool = false
var speed : float
var jump_velocity : float
var jumping : bool = false
var _sonar_emit : bool = true
var _was_in_air: bool = false

func _ready() -> void:
	if(_player_data == null):
		printerr("Load player_data before adding to the tree: " + str(get_stack()))
	_connect_signals()
	add_to_group("Player")
	_init_data()

func _connect_signals()->void:
	_interaction_area.area_entered.connect(_on_interaction_area_entered)
	_sonar_cooldown.timeout.connect(_on_sonar_cooldown)

func _init_data() -> void:
	speed = _player_data.speed
	jump_velocity = _player_data.jump_velocity
	_steps_emitter_cooldown.wait_time = emit_cooldown
	_sonar_cooldown.wait_time = disappear_time + revealing_time + reveal_time

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
	
	if Input.is_action_just_pressed("sonar") and _sonar_emit:
		var sonar: Sonar = _sonar_scene_ps.instantiate()
		get_tree().current_scene.add_child(sonar)
		_sonar_emit = false
		EventBus._sonar_emitted.emit(_echo_pos.global_position, size_relative_to_radius, revealing_time, _echo_pos.get_angle_to(get_global_mouse_position()) + PI/2)
		_sonar_cooldown.start()
		sonar.set_sonar_parametres(reveal_time,disappear_time,revealing_time,size_relative_to_radius)
		sonar.emit_sonar(_echo_pos.global_position, _echo_pos.get_angle_to(get_global_mouse_position()) + PI/2 )
		
	if(Input.is_action_just_pressed("interact")):
		_try_to_activate_button()
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, speed)
	_emit_steps(get_last_slide_collision())
	move_and_slide()
	if(_is_landed()):
		_burst_lights()
## _physics_process END

func _try_to_activate_button() -> void:
	for i: Area2D in _interaction_area.get_overlapping_areas():
		if(i is InteractiveButton):
			(i as InteractiveButton).activate_button()

func _on_interaction_area_entered(area: Area2D) -> void:
	if(area is InteractiveDoor):
		Global.scenes_layout.last_scene = (area as InteractiveDoor).level_to_load
		SceneManager.load_scene((area as InteractiveDoor).level_to_load)

func _emit_steps(collision_data: KinematicCollision2D) -> void:
	if(_steps_emitter_cooldown.is_stopped() and collision_data != null and velocity.length() != 0):
		_steps_emitter_cooldown.start()
		print(str(collision_data.get_angle()) + " ! " + str(deg_to_rad(self.floor_max_angle))) 
		if(!_step_player.playing and 
		abs(collision_data.get_angle()) < self.floor_max_angle):
			_step_player.play()
		elif(!_collide_with_walls_roofs_player.playing and 
		abs(collision_data.get_angle()) > self.floor_max_angle):
			_collide_with_walls_roofs_player.play()
	else:
		return
	var j: int = 0
	for i: Step in _steps_pool:
		if(i != Step):
			_steps_pool.pop_at(j)	
		j+=1
	if(_steps_pool.size() < emit_capacity):
		var step: Step = _step_scene_ps.instantiate()
		get_tree().current_scene.add_child(step)
		var random_circle_emition: Vector2 = Vector2(randf_range(-15.0,15.0),randf_range(-15.0,15.0))
		step.emit_step(collision_data.get_position() + random_circle_emition, max_size, min_size, time_to_vanish)
		_steps_pool.push_front(step)

func _is_landed() -> bool:
	var just_landed: bool = (_was_in_air and is_on_floor())
	_was_in_air = !is_on_floor()
	return just_landed

func _burst_lights() -> void:
	for i: int in range(emit_count_on_landing):
		var step: Step = _step_scene_ps.instantiate()
		get_tree().current_scene.add_child(step)
		var random_circle_emition: Vector2 = Vector2(randf_range(-15.0,15.0),randf_range(-15.0,15.0))
		var centre: Vector2 =Vector2(player_collision.global_position.x, 
		player_collision.global_position.y + (player_collision.shape as CapsuleShape2D).height/2)
		
		step.emit_step(centre + random_circle_emition, max_size, min_size, time_to_vanish)
		jump_sound.play()

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)

func _on_sonar_cooldown() -> void:
	_sonar_emit = true
