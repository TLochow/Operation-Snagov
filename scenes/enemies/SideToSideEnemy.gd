extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

onready var ShootCooldownCounter = ShootCooldown + rand_range(0.0, ShootCooldown)
export(float) var ShootCooldown = 2.0
export(float) var ShootAmount = 1.0
export(float) var ShootDamage = 1.0
export(float) var ShootSpread = 0.0

export(float) var MoveSpeed = 50.0
export(float) var MoveSpeedDeviation = 0.2

var BaseMovement
var MovingNegative = false

export(Default.Directions) var HorizontalMoveDirection
export(Default.Directions) var VerticalMoveDirection
export(Default.Directions) var HorizontalLookDirection
export(Default.Directions) var VerticalLookDirection

var ShootDir

func _ready():
	._ready()
	MovingNegative = randi() % 2 == 0
	MoveSpeed += MoveSpeed * rand_range(-MoveSpeedDeviation, MoveSpeedDeviation)

func Activate():
	.Activate()
	$AnimationPlayer.play("Walk")
	var angleToPlayer = (Player.get_position() - get_global_position()).angle()
	var isVertical = (angleToPlayer < 0.5 and angleToPlayer > -0.5) or (angleToPlayer > 2.5 or angleToPlayer < -2.5)
	var moveDirToMatch = HorizontalMoveDirection
	var lookDirToMatch = HorizontalLookDirection
	if isVertical:
		moveDirToMatch = VerticalMoveDirection
		lookDirToMatch = VerticalLookDirection
	match moveDirToMatch:
		Default.Directions.Up:
			BaseMovement = Default.DirUp
		Default.Directions.Down:
			BaseMovement = Default.DirDown
		Default.Directions.Left:
			BaseMovement = Default.DirLeft
		Default.Directions.Right:
			BaseMovement = Default.DirRight
	match lookDirToMatch:
		Default.Directions.Up:
			$Sprite.rotation_degrees = -90.0
			ShootDir = Default.DirUp
		Default.Directions.Down:
			$Sprite.rotation_degrees = 90.0
			ShootDir = Default.DirDown
		Default.Directions.Left:
			$Sprite.rotation_degrees = 180.0
			ShootDir = Default.DirLeft
		Default.Directions.Right:
			ShootDir = Default.DirRight

func _physics_process(delta):
	var move = BaseMovement
	if MovingNegative:
		move *= -1.0
	var collision = move_and_collide(move * delta * MoveSpeed)
	if collision:
		MovingNegative = not MovingNegative
	
	ShootCooldownCounter -= delta
	if ShootCooldownCounter <= 0.0:
		Shoot(ShootDir)

func Shoot(direction):
	ShootCooldownCounter = ShootCooldown
	var shootPos = get_global_position() + (direction.normalized() * 6.0)
	for i in range(ShootAmount):
		var shot = SHOTSCENE.instance()
		ShotNode.add_child(shot)
		shot.set_position(shootPos)
		var shootAngle = direction.angle() + rand_range(-ShootSpread, ShootSpread)
		shot.Shoot(ShootDamage, shootAngle)
