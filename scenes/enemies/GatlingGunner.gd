extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")

export(float) var ShootDamage = 1.0
export(float) var ShootSpread = 0.1

var Phase = "Warmup"
var WarmupPhaseDuration = 4.0
var ShootPhaseDuration = 2.0
var CurrentPhaseDuration = WarmupPhaseDuration * 2.0

var ShieldDestroyed = false

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]
onready var Position = get_global_position()
onready var StandSprite = $Stand

func Activate():
	.Activate()
	var dirToPlayer = Player.get_position() - Position
	rotation = dirToPlayer.angle()

func _process(delta):
	var dirToPlayer = Player.get_position() - Position
	rotation = lerp_angle(rotation, dirToPlayer.angle(), 0.02)
	StandSprite.rotation = -rotation
	match Phase:
		"Warmup":
			CurrentPhaseDuration -= delta
			if CurrentPhaseDuration <= 0.0:
				Phase = "Shoot"
				CurrentPhaseDuration = ShootPhaseDuration
		"Shoot":
			Shoot(rotation)
			CurrentPhaseDuration -= delta
			if CurrentPhaseDuration <= 0.0:
				Phase = "Warmup"
				CurrentPhaseDuration = WarmupPhaseDuration

func Shoot(direction):
	var shootPos = Position + (Vector2(cos(direction), sin(direction)) * 14.0)
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(shootPos)
	var shootAngle = direction + rand_range(-ShootSpread, ShootSpread)
	shot.Shoot(ShootDamage, shootAngle)

func _on_GatlingShield_Destroyed():
	ShieldDestroyed = true

func Die(forceDirection):
	var pos = get_global_position()
	for i in range(24):
		var angle = TAU * (i / 24.0)
		Bleed(pos, angle, 0.5)
	SpawnDebrisForSprite(StandSprite, forceDirection)
	SpawnDebrisForSprite($Gun, forceDirection)
	if not ShieldDestroyed:
		SpawnDebrisForSprite($GatlingShield/Shield, forceDirection)
	call_deferred("queue_free")

func SpawnDebrisForSprite(sprite, forceDirection):
	DebrisSpawner.SpawnDebris(sprite, rotation, forceDirection, sprite.get_global_position())
