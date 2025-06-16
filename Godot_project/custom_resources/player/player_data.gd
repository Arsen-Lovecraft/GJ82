class_name RplayerData
extends Resource

signal dead()
signal levelUp

@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
@export var gravity :Vector2 = Vector2(0.0,980.0)

@export var hp: float = 100:
	set(value):
		hp = value
		if(hp <= 0):
			dead.emit()
@export var mp: float = 50:
	get:
		return mp
	set(value):
		mp = value
		if(mp >= 100):
			levelUp.emit()
			
@export var damage: float = 100
@export var attack_cooldown: float = 1.0
