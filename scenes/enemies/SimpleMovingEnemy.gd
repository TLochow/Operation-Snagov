extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
var Position

onready var SpriteNode = $Sprite

var ShootCooldown = 2.0
var ShootCooldownReset = 2.0

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
