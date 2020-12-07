extends RigidBody2D

onready var Player = get_tree().get_nodes_in_group("Player")[0]
var DirectionToPlayer

var BLOODSCENE = preload("res://scenes/effects/Blood.tscn")
var SPARKSCENE = preload("res://scenes/effects/Sparks.tscn")
var BURNHANDLERSCENE = preload("res://scenes/BurnHandler.tscn")

export(float) var Health = 5.0
export(Default.EnemyTypes) var EnemyType

var Active = false
var Dead = false

func _ready():
	set_process(false)
	set_physics_process(false)

func Activate():
	Active = true
	set_process(true)
	set_physics_process(true)

func Damage(damage, hitPoint, direction, collisionNormal):
	if Active:
		match EnemyType:
			Default.EnemyTypes.Alive:
				Bleed(hitPoint, direction.angle(), damage)
			Default.EnemyTypes.Mechanical:
				Spark(hitPoint)
		Health -= damage
		if Health <= 0.0:
			Die(direction)

func Explode(pos, strength):
	if Active:
		Health -= strength
		if Health <= 0.0:
			Die(pos - get_global_position())

func Burn(damage):
	if not Dead:
		Health -= damage
		if Health <= 0.0:
			Dead = true
			Global.KillCounter += 1
			add_child(BURNHANDLERSCENE.instance())

func Bleed(pos, angle, damage):
	for i in range(10 * damage):
		var blood = BLOODSCENE.instance()
		blood.set_position(pos)
		blood.Direction = angle + rand_range(-0.2, 0.2)
		blood.Speed = damage * rand_range(0.8, 1.2)
		Global.TopEffectsNode.add_child(blood)

func Spark(pos):
	var spark = SPARKSCENE.instance()
	spark.set_position(pos)
	Global.TopEffectsNode.add_child(spark)

func Die(forceDirection):
	if not Dead:
		Dead = true
		Global.KillCounter += 1
		var pos = get_global_position()
		match EnemyType:
			Default.EnemyTypes.Alive:
				for i in range(24):
					var angle = TAU * (i / 24.0)
					Bleed(pos, angle, 0.5)
			Default.EnemyTypes.Mechanical:
				DebrisSpawner.SpawnDebris($Sprite, rotation, forceDirection, pos)
		call_deferred("queue_free")

func _physics_process(delta):
	var playerPos = Player.get_position()
	var pos = get_global_position()
	
	DirectionToPlayer = playerPos - pos
	var squareDistance = clamp(DirectionToPlayer.length_squared() * 0.000001, 0.1, 0.8)
	var gravityDirection = DirectionToPlayer.normalized()
	var gravityForce = gravityDirection * 2.0 / squareDistance
	linear_velocity += gravityForce * 6.0 * delta
	
	rotation = lerp_angle(rotation, DirectionToPlayer.angle(), 0.1)

func _on_SmallDrone_body_entered(body):
	if body.is_in_group("Player"):
		body.Damage(1.0, body.get_position(), DirectionToPlayer, -DirectionToPlayer)
		Damage(10.0, get_global_position(), -DirectionToPlayer, DirectionToPlayer)
