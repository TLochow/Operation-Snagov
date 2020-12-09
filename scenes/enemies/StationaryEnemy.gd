extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
onready var Position = get_global_position()

onready var SpriteNode = $Sprite
var Angle

onready var ShootCooldownCounter = ShootCooldown + rand_range(0.0, ShootCooldown)
export(float) var ShootCooldown = 2.0
export(float) var ShootAmount = 1.0
export(float) var ShootDamage = 1.0
export(float) var ShootSpread = 0.1
export(float) var RotationSpeed = 0.1

func _ready():
	Angle = (Player.get_position() - Position).angle()
	._ready()

func _process(delta):
	var direction = Player.get_position() - Position
	Angle = lerp_angle(Angle, direction.angle(), RotationSpeed)
	SpriteNode.rotation = Angle
	ShootCooldownCounter -= delta
	if ShootCooldownCounter <= 0.0:
		Shoot()

func Shoot():
	var direction = Vector2(cos(Angle), sin(Angle))
	ShootCooldownCounter = ShootCooldown
	var shootPos = Position + (direction.normalized() * 6.0)
	for i in range(ShootAmount):
		var shot = SHOTSCENE.instance()
		ShotNode.add_child(shot)
		shot.set_position(shootPos)
		var shootAngle = direction.angle() + rand_range(-ShootSpread, ShootSpread)
		shot.Shoot(ShootDamage, shootAngle)
