extends "res://scenes/objects/DestructibleObject.gd"

func _ready():
	$Sprite.frame = randi() % 3
