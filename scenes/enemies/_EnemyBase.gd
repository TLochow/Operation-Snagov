extends KinematicBody2D

var BLOODSCENE = preload("res://scenes/effects/Blood.tscn")

export(float) var Health = 5.0

var Active = false

func _ready():
	visible = false
	set_process(false)
	set_physics_process(false)

func Activate():
	visible = true
	Active = true
	set_process(true)
	set_physics_process(true)

func Damage(damage, hitPoint, direction, collisionNormal):
	if Active:
		Bleed(hitPoint, direction, damage)
		Health -= damage
		if Health <= 0.0:
			queue_free()

func Bleed(pos, direction, damage):
	for i in range(10):
		var blood = BLOODSCENE.instance()
		blood.set_position(pos)
		blood.Direction = direction.angle() + rand_range(-0.2, 0.2)
		blood.Speed = damage * rand_range(0.8, 1.2)
		Global.TopEffectsNode.add_child(blood)
