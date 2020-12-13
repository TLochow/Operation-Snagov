extends StaticBody2D

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")
var FIRESCENE = preload("res://scenes/shots/Fire.tscn")

onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
var ShotPos
var LookDirection

export(bool) var Armed = false
export(bool) var ShootingFire = false

var ShootCooldownCounter = 0.0
export(float) var ShootCooldown = 0.1
export(float) var ShootAmount = 1.0
export(float) var ShootDamage = 1.0
export(float) var ShootSpread = 0.1

func _process(delta):
	if Armed:
		ShootCooldownCounter -= delta
		if ShootCooldownCounter <= 0.0:
			ShootCooldownCounter = ShootCooldown
			var rot = get_global_transform().get_rotation()
			LookDirection = Vector2(cos(rot), sin(rot)) * 10.0
			ShotPos = get_global_position() + LookDirection
			if ShootingFire:
				for i in range(ShootAmount):
					ThrowFlames()
			else:
				for i in range(ShootAmount):
					Shoot()

func Shoot():
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(ShotPos)
	var angle = get_global_transform().get_rotation() + rand_range(-ShootSpread, ShootSpread)
	shot.Shoot(ShootDamage, angle)

func ThrowFlames():
	var fire = FIRESCENE.instance()
	fire.set_position(ShotPos)
	fire.linear_velocity = (LookDirection * 50.0).rotated(rand_range(-ShootSpread, ShootSpread))
	ShotNode.add_child(fire)
