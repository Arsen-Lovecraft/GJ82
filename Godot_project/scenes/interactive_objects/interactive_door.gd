class_name InteractiveDoor
extends Area2D

@export var level_to_load: String

@onready var _door_open_sound: AudioStreamPlayer = %DoorOpenSound
@onready var _door_animation_player: AnimationPlayer = %DoorAnimationPlayer

func _ready() -> void:
	if(level_to_load == null):
		printerr("Interactive door has not a level to transit to")

func open() -> void:
	self.monitorable = true
	_door_open_sound.play()
	_door_animation_player.play("door_open_light")

func close() -> void:
	self.monitorable = false
