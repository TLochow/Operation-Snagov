extends "res://scenes/objects/DestructibleObject.gd"

func _ready():
	rotation += PI * (randi() % 4)
