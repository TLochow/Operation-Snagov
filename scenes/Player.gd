extends KinematicBody2D

signal HealthChanged(health, maxHealth)
signal GrenadesChanged(grenades)
signal ArmorChanged(armor)
signal MoneyChanged(money)

var SHOTSCENE = preload("res://scenes/Shot.tscn")
var GRENADESCENE = preload("res://scenes/Grenade.tscn")
var BLOODSCENE = preload("res://scenes/effects/Blood.tscn")

onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

onready var AnimPlayer = $AnimationPlayer
var PlayingWalkAnimation = true
onready var PlayerSprite = $Sprite

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

var ImpactDetector = false
var GrenadeLauncher = false
var BlastShield = false

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
	
	ImpactDetector = Global.PlayerImpactDetector
	GrenadeLauncher = Global.PlayerGrenadeLauncher
	BlastShield = Global.PlayerBlastShield

func _input(event):
	if event.is_action_pressed("mouse_right") and Grenades > 0:
		GrenadesSet(Grenades - 1)
		ThrowGrenade(ImpactDetector)

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
	move_and_slide(MoveDirection.normalized() * 100.0, Default.DirCenter)
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
	
	ShootCooldownCounter -= delta
	if Input.is_action_pressed("mouse_left") and ShootCooldownCounter <= 0.0:
		var shootPos = pos + (LookDirection * 6.0)
		Shoot(lookAngle, shootPos)

func Shoot(angle, pos):
	ShootCooldownCounter = ShootCooldown
	if GrenadeLauncher:
		ThrowGrenade(true)
	else:
		for i in range(ShotAmount):
			var shot = SHOTSCENE.instance()
			ShotNode.add_child(shot)
			shot.set_position(pos)
			shot.Shoot(ShotDamage, angle + rand_range(-ShotSpread, ShotSpread))

func ThrowGrenade(explodeOnContact):
	var pos = get_position() + (LookDirection * 10.0)
	var grenade = GRENADESCENE.instance()
	grenade.ExplodeOnContact = explodeOnContact
	grenade.set_position(pos)
	grenade.linear_velocity = LookDirection * 500.0
	grenade.angular_velocity = rand_range(-10.0, 10.0)
	ShotNode.add_child(grenade)

func Damage(damage, hitPoint, direction, collisionNormal):
	TakeDamage(damage)
	Bleed(hitPoint, direction, damage)

func Explode(pos, strength):
	if not BlastShield:
		TakeDamage(strength)

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
	Health = clamp(ceil(health), 0, MaxHealth)
	emit_signal("HealthChanged", Health, MaxHealth)
	if Health <= 0.0:
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func MaxHealthSet(maxHealth):
	MaxHealth = max(maxHealth, 1)
	Health = min(Health, MaxHealth)
	emit_signal("HealthChanged", Health, MaxHealth)

func GrenadesSet(grenades):
	Grenades = max(grenades, 0)
	emit_signal("GrenadesChanged", Grenades)

func ArmorSet(armor):
	Armor = max(ceil(armor), 0)
	emit_signal("ArmorChanged", Armor)

func MoneySet(money):
	Money = max(money, 0)
	emit_signal("MoneyChanged", Money)
