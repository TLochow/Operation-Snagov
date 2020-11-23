extends "res://scenes/objects/DestructibleObject.gd"

func _ready():
	$Sprite.frame = randi() % 4
	if randi() % 2 == 0:
		$Sprite.rotation += PI
