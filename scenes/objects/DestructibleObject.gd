extends StaticBody2D

var WALLHITSCENE = preload("res://scenes/effects/WallHit.tscn")
var PICKUPSCENE = preload("res://scenes/Pickup.tscn")
var BURNHANDLERSCENE = preload("res://scenes/BurnHandler.tscn")

export(float) var Health = 10.0
var Destroyed = false

export(bool) var SpawnPickups = false
export(float, 0.0, 1.0, 0.01) var HealthChance = 0.0
export(float, 0.0, 1.0, 0.01) var GrenadeChance = 0.0
export(float, 0.0, 1.0, 0.01) var ArmorChance = 0.0
export(float, 0.0, 1.0, 0.01) var MoneyChance = 0.0

export(Default.SoundEffects) var BreakingSoundEffect

func Damage(damage, hitPoint, direction, collisionNormal):
	var hitEffect = WALLHITSCENE.instance()
	hitEffect.set_position(hitPoint)
	hitEffect.rotation = collisionNormal.angle()
	Global.TopEffectsNode.add_child(hitEffect)
	
	Health -= damage
	if Health <= 0.0:
		Destroy(direction)

func Explode(pos, strength):
	Health -= strength * 2.0
	if Health <= 0.0:
		Destroy((pos - get_position()).normalized())

func Burn(damage):
	if not Destroyed:
		Health -= damage
		if Health <= 0.0:
			Destroyed = true
			add_child(BURNHANDLERSCENE.instance())

func Destroy(forceDirection):
	if not Destroyed:
		Destroyed = true
		var pos = get_global_position()
		if SpawnPickups:
			SpawnPickups(pos)
		DebrisSpawner.SpawnDebris($Sprite, rotation, forceDirection, pos)
		SoundEffectHandler.Play(BreakingSoundEffect)
		call_deferred("queue_free")

func SpawnPickups(pos):
	var spawnMod = 1.0
	if Global.CloverLeaf:
		spawnMod = 0.5
	if HealthChance > 0.0 and randf() * spawnMod <= HealthChance:
		SpawnPickup(pos, Default.PickupTypes.Health)
	if GrenadeChance > 0.0 and randf() * spawnMod <= GrenadeChance:
		SpawnPickup(pos, Default.PickupTypes.Grenade)
	if ArmorChance > 0.0 and randf() * spawnMod <= ArmorChance:
		SpawnPickup(pos, Default.PickupTypes.Armor)
	if MoneyChance > 0.0 and randf() * spawnMod <= MoneyChance:
		SpawnPickup(pos, Default.PickupTypes.Money)

func SpawnPickup(pos, type):
	var pickup = PICKUPSCENE.instance()
	pickup.set_position(pos)
	pickup.Type = type
	Global.DebrisNode.call_deferred("add_child", pickup)
