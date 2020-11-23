extends TileMap

var WALLHITSCENE = preload("res://scenes/effects/WallHit.tscn")

func Damage(damage, hitPoint, direction, collisionNormal):
	var hitEffect = WALLHITSCENE.instance()
	hitEffect.set_position(hitPoint)
	hitEffect.rotation = collisionNormal.angle()
	Global.EffectsNode.add_child(hitEffect)
