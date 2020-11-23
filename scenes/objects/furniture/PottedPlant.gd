extends "res://scenes/objects/DestructibleObject.gd"

func _ready():
	$Sprite.rotation = rand_range(-PI, PI)
	$Sprite.frame = randi() % 3
