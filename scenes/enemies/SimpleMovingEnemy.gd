extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
var Position

onready var SpriteNode = $Sprite

onready var ShootCooldownCounter = ShootCooldown + rand_range(0.0, ShootCooldown)
export(float) var ShootCooldown = 2.0
export(float) var ShootAmount = 1.0
export(float) var ShootDamage = 1.0
export(float) var ShootSpread = 0.1

export(bool) var HorizontalMovement = true
var MovingNegative = false
var BaseMovement

func _ready():
	._ready()
	MovingNegative = randi() % 2 == 0
	BaseMovement = Default.DirDown
	if HorizontalMovement:
		BaseMovement = Default.DirRight

func Activate():
	.Activate()
	$AnimationPlayer.play("Walk")

func _physics_process(delta):
	var move = BaseMovement
	if MovingNegative:
		move *= -1.0
	var collision = move_and_collide(move * delta * 50.0)
	if collision:
		MovingNegative = not MovingNegative
	
	Position = get_global_position()
	var direction = Player.get_position() - Position
	var angle = direction.angle()
	SpriteNode.rotation = angle
	ShootCooldownCounter -= delta
	if ShootCooldownCounter <= 0.0:
		Shoot(direction)

func Shoot(direction):
	ShootCooldownCounter = ShootCooldown
	var shootPos = Position + (direction.normalized() * 6.0)
	for i in range(ShootAmount):
		var shot = SHOTSCENE.instance()
		ShotNode.add_child(shot)
		shot.set_position(shootPos)
		var shootAngle = direction.angle() + rand_range(-ShootSpread, ShootSpread)
		shot.Shoot(ShootDamage, shootAngle)
