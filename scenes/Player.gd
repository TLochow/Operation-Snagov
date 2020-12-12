extends KinematicBody2D

signal HealthChanged(health, maxHealth)
signal GrenadesChanged(grenades)
signal ArmorChanged(armor)
signal MoneyChanged(money)

signal Died

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")
var GRENADESCENE = preload("res://scenes/shots/Grenade.tscn")
var FIRESCENE = preload("res://scenes/shots/Fire.tscn")
var BLOODSCENE = preload("res://scenes/effects/Blood.tscn")
var DRONESCENE = preload("res://scenes/items/Drone.tscn")
var DEFENSIVEDRONESSCENE = preload("res://scenes/items/DefensiveDrones.tscn")
var SHIELDSCENE = preload("res://scenes/items/Shield.tscn")

onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

onready var AnimPlayer = $AnimationPlayer
var PlayingWalkAnimation = true
onready var PlayerSprite = $Sprite
onready var ShieldNode = $Shield

var LookDirection = Vector2(0.0, 0.0)
var MoveDirection = Vector2(0.0, 0.0)


var Health = 10 setget HealthSet
var MaxHealth setget MaxHealthSet
var Grenades setget GrenadesSet
var Armor setget ArmorSet
var Money setget MoneySet

var ShootCooldown
var ShootCooldownCounter = 0.0
var ShotSpread
var ShotAmount
var ShotDamage
var MoveSpeed

var ImpactDetector
var GrenadeLauncher
var FlameThrower
var BlastShield
var FlameShield
var Shield
var Drone
var DefensiveDrones
var Revenge

func _ready():
	LoadPlayerValues()
	AnimPlayer.play("Walk")

func LoadPlayerValues():
	MaxHealthSet(Global.PlayerMaxHealth)
	HealthSet(Global.PlayerHealth)
	GrenadesSet(Global.PlayerGrenades)
	ArmorSet(Global.PlayerArmor)
	MoneySet(Global.PlayerMoney)
	
	ShootCooldown = Global.PlayerShootCooldown
	ShotSpread = Global.PlayerShotSpread
	ShotAmount = Global.PlayerShotAmount
	ShotDamage = Global.PlayerShotDamage
	MoveSpeed = Global.PlayerMoveSpeed
	
	ImpactDetector = Global.PlayerImpactDetector
	GrenadeLauncher = Global.PlayerGrenadeLauncher
	FlameThrower = Global.PlayerFlameThrower
	BlastShield = Global.PlayerBlastShield
	FlameShield = Global.PlayerFlameShield
	if Global.PlayerShield:
		ActivateShield()
	if Global.PlayerDrone:
		ActivateDrone()
	if Global.PlayerDefenisveDrones:
		ActivateDefensiveDrones()
	Revenge = Global.PlayerRevenge

func _input(event):
	if event.is_action_pressed("mouse_right") and Grenades > 0:
		GrenadesSet(Grenades - 1)
		ThrowGrenade(ImpactDetector, false)

func _physics_process(delta):
	MoveDirection = Default.DirCenter
	if Input.is_action_pressed("ui_left"):
		MoveDirection += Default.DirLeft
	if Input.is_action_pressed("ui_right"):
		MoveDirection += Default.DirRight
	if Input.is_action_pressed("ui_up"):
		MoveDirection += Default.DirUp
	if Input.is_action_pressed("ui_down"):
		MoveDirection += Default.DirDown
	move_and_slide(MoveDirection.normalized() * MoveSpeed, Default.DirCenter)
	if MoveDirection == Default.DirCenter:
		if PlayingWalkAnimation:
			AnimPlayer.stop(false)
			PlayingWalkAnimation = false
	else:
		if not PlayingWalkAnimation:
			AnimPlayer.play()
			PlayingWalkAnimation = true
	
	var pos = get_position()
	LookDirection = (.get_global_mouse_position() - pos).normalized()
	var lookAngle = LookDirection.angle()
	PlayerSprite.rotation = lookAngle
	ShieldNode.rotation = lookAngle
	
	ShootCooldownCounter -= delta
	if Input.is_action_pressed("mouse_left"):
		if FlameThrower:
			ThrowFlames()
		if ShootCooldownCounter <= 0.0:
			var shootPos = pos + (LookDirection * 6.0)
			Shoot(lookAngle, shootPos)

func Shoot(angle, pos):
	ShootCooldownCounter = ShootCooldown
	var shot = FlameThrower
	if GrenadeLauncher:
		shot = true
		for i in range(ShotAmount):
			ThrowGrenade(true, true)
	if not shot:
		for i in range(ShotAmount):
			SingleShot(pos, angle + rand_range(-ShotSpread, ShotSpread))

func SingleShot(pos, angle):
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(pos)
	shot.Shoot(ShotDamage, angle)

func ThrowGrenade(explodeOnContact, applySpread):
	var pos = get_position() + (LookDirection * 10.0)
	var grenade = GRENADESCENE.instance()
	grenade.ExplodeOnContact = explodeOnContact
	grenade.set_position(pos)
	grenade.linear_velocity = LookDirection * 500.0
	if applySpread:
		grenade.linear_velocity = grenade.linear_velocity.rotated(rand_range(-ShotSpread, ShotSpread))
	grenade.angular_velocity = rand_range(-10.0, 10.0)
	ShotNode.add_child(grenade)

func ThrowFlames():
	var pos = get_position() + (LookDirection * 14.0)
	var fire = FIRESCENE.instance()
	fire.set_position(pos)
	fire.linear_velocity = (LookDirection * 500.0).rotated(rand_range(-ShotSpread, ShotSpread))
	ShotNode.call_deferred("add_child", fire)

func Damage(damage, hitPoint, direction, collisionNormal):
	TakeDamage(damage)
	Bleed(hitPoint, direction, damage)
	if Revenge:
		var shotDir = direction.rotated(PI)
		SingleShot(hitPoint + (shotDir.normalized() * 6.0), shotDir.angle())

func Explode(pos, strength):
	if not BlastShield:
		TakeDamage(strength)

func Burn(damage):
	if not FlameShield:
		TakeDamage(damage)

func TakeDamage(damage):
	if Armor > 0.0:
		ArmorSet(Armor - damage)
	else:
		HealthSet(Health - damage)

func Bleed(pos, direction, damage):
	for i in range(20 * damage):
		var blood = BLOODSCENE.instance()
		blood.set_position(pos)
		blood.Direction = direction.angle() + rand_range(-0.2, 0.2)
		blood.Speed = damage * rand_range(0.8, 1.2)
		Global.TopEffectsNode.add_child(blood)

func HealthSet(health):
	Health = clamp(stepify(health, 0.01), 0, MaxHealth)
	emit_signal("HealthChanged", Health, MaxHealth)
	if Health <= 0.0 and not Global.GameOver:
		emit_signal("Died")

func MaxHealthSet(maxHealth):
	MaxHealth = max(maxHealth, 1)
	Health = min(Health, MaxHealth)
	emit_signal("HealthChanged", Health, MaxHealth)

func GrenadesSet(grenades):
	Grenades = max(grenades, 0)
	emit_signal("GrenadesChanged", Grenades)

func ArmorSet(armor):
	Armor = max(stepify(armor, 0.01), 0)
	emit_signal("ArmorChanged", Armor)

func MoneySet(money):
	Money = max(money, 0)
	emit_signal("MoneyChanged", Money)

func ActivateDrone():
	Drone = true
	var drone = DRONESCENE.instance()
	drone.set_position(get_position())
	ShotNode.call_deferred("add_child", drone)

func ActivateDefensiveDrones():
	DefensiveDrones = true
	var drones = DEFENSIVEDRONESSCENE.instance()
	call_deferred("add_child", drones)

func ActivateShield():
	Shield = true
	var shield = SHIELDSCENE.instance()
	shield.rotation = PI
	shield.Explodable = false
	shield.set_position(Vector2(-4.0, 0.0))
	ShieldNode.call_deferred("add_child", shield)
