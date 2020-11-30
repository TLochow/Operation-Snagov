extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/Shot.tscn")

export(float) var TurnDuration = 1.0
export(float) var WarmUpTime = 1.0
export(float) var ShootDamage = 1.0

onready var TurnTween = $Tween
onready var SpriteNode = $Sprite
onready var Position = get_global_position()
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

func Activate():
	.Activate()
	$WarmupTimer.wait_time = WarmUpTime
	$WarmupTimer.start()

func _on_WarmupTimer_timeout():
	Turn()

func _on_Tween_tween_all_completed():
	Shoot(Default.DirUp)
	Shoot(Default.DirDown)
	Shoot(Default.DirLeft)
	Shoot(Default.DirRight)
	Turn()

func Turn():
	TurnTween.interpolate_property(SpriteNode, "rotation", 0.0, PI * 0.5, TurnDuration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	TurnTween.start()

func Shoot(direction):
	var shootPos = Position + (direction.normalized() * 6.0)
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(shootPos)
	shot.Shoot(ShootDamage, direction.angle())
