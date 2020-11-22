extends KinematicBody2D

var Health = 2.0

var Active = false

func _ready():
	visible = false
	set_process(false)

func Activate():
	visible = true
	Active = true
	set_process(true)

func Damage(damage, hitPoint, direction):
	if Active:
		Health -= damage
		if Health <= 0.0:
			queue_free()
