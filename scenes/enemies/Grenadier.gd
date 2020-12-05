extends "res://scenes/enemies/_EnemyBase.gd"

var GRENADESCENE = preload("res://scenes/Grenade.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
onready var Position = get_global_position()

onready var SpriteNode = $Sprite

onready var ShootCooldownCounter = ShootCooldown + rand_range(0.0, ShootCooldown)
export(float) var ShootCooldown = 5.0
export(float) var ShootAmount = 1.0
export(float) var ShootSpread = 0.1

func _process(delta):
	var direction = Player.get_position() - Position
	var angle = direction.angle()
	SpriteNode.rotation = angle
	ShootCooldownCounter -= delta
	if ShootCooldownCounter <= 0.0:
		Shoot(direction.normalized())

func Shoot(direction):
	ShootCooldownCounter = ShootCooldown
	var shootPos = Position + (direction * 12.0)
	for i in range(ShootAmount):
		var grenade = GRENADESCENE.instance()
		grenade.ExplodeOnContact = false
		grenade.set_position(shootPos)
		grenade.linear_velocity = (direction * 500.0).rotated(rand_range(-ShootSpread, ShootSpread))
		grenade.angular_velocity = rand_range(-10.0, 10.0)
		ShotNode.add_child(grenade)
