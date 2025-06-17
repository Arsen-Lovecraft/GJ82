class_name InteractiveDoor
extends Area2D

@export var level_to_load: String

func _ready() -> void:
	if(level_to_load == null):
		printerr("Interactive door has not a level to transit to")

func open() -> void:
	self.monitorable = true

func close() -> void:
	self.monitorable = false
