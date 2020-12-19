extends Node2D

onready var LeftSprite = $LeftDrone/Sprite
onready var RightSprite = $RightDrone/Sprite

func _process(delta):
	rotation = wrapf(rotation + (delta * 2.0), 0.0, TAU)
	LeftSprite.rotation = -rotation
	RightSprite.rotation = -rotation
