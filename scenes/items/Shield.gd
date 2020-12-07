extends StaticBody2D

var WALLHITSCENE = preload("res://scenes/effects/WallHit.tscn")

export(bool) var Explodable = true
export(float) var Health = 10.0
var Destroyed = false

func Damage(damage, hitPoint, direction, collisionNormal):
	var hitEffect = WALLHITSCENE.instance()
	hitEffect.set_position(hitPoint)
	hitEffect.rotation = collisionNormal.angle()
	Global.TopEffectsNode.add_child(hitEffect)

func Explode(pos, strength):
	if Explodable:
		Health -= strength
		if Health <= 0.0:
			Destroy((pos - get_position()).normalized())

func Destroy(forceDirection):
	if not Destroyed:
		Destroyed = true
		var pos = get_global_position()
		DebrisSpawner.SpawnDebris($Sprite, rotation, forceDirection, pos)
		call_deferred("queue_free")
