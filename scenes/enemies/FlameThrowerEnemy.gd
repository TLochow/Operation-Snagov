extends "res://scenes/enemies/_EnemyBase.gd"

var FIRESCENE = preload("res://scenes/shots/Fire.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
onready var Position = get_global_position()

onready var SpriteNode = $Sprite

onready var PhaseCounter = WaitPhaseLength + rand_range(0.0, WaitPhaseLength)
export(float) var WaitPhaseLength = 2.0
export(float) var FirePhaseLength = 0.5
export(float) var ShootSpread = 0.1

var Firing = false

func _process(delta):
	var direction = Player.get_position() - Position
	var angle = direction.angle()
	SpriteNode.rotation = angle
	
	if Firing:
		ThrowFlames(direction.normalized())
	
	PhaseCounter -= delta
	if PhaseCounter <= 0.0:
		Firing = not Firing
		if Firing:
			PhaseCounter = FirePhaseLength
		else:
			PhaseCounter = WaitPhaseLength

func ThrowFlames(direction):
	var fire = FIRESCENE.instance()
	fire.set_position(Position + (direction * 14.0))
	fire.linear_velocity = (direction * 500.0).rotated(rand_range(-ShootSpread, ShootSpread))
	ShotNode.add_child(fire)
