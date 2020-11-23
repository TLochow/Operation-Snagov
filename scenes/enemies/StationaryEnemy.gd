extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
onready var Position = get_global_position()

onready var SpriteNode = $Sprite

var ShootCooldown = 2.0
var ShootCooldownReset = 2.0

func _process(delta):
	var direction = Player.get_position() - Position
	var angle = direction.angle()
	SpriteNode.rotation = angle
	ShootCooldown -= delta
	if ShootCooldown <= 0.0:
		Shoot(direction)

func Shoot(direction):
	ShootCooldown = ShootCooldownReset
	var shootPos = Position + (direction.normalized() * 6.0)
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(shootPos)
	shot.Shoot(1.0, direction.angle())
