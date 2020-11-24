extends KinematicBody2D

var SHOTSCENE = preload("res://scenes/Shot.tscn")
var BLOODSCENE = preload("res://scenes/effects/Blood.tscn")

onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

onready var AnimPlayer = $AnimationPlayer
var PlayingWalkAnimation = true
onready var PlayerSprite = $Sprite

var LookDirection = Vector2(0.0, 0.0)
var MoveDirection = Vector2(0.0, 0.0)

var ShootCooldown = 0.1
var ShootCooldownCounter = 0.0
var ShotSpread = 0.1
var ShotAmount = 1.0
var ShotDamage = 1.0

func _ready():
	AnimPlayer.play("Walk")

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
	for i in range(ShotAmount):
		var shot = SHOTSCENE.instance()
		ShotNode.add_child(shot)
		shot.set_position(pos)
		shot.Shoot(ShotDamage, angle + rand_range(-ShotSpread, ShotSpread))

func Damage(damage, hitPoint, direction, collisionNormal):
	Bleed(direction, damage)

func Bleed(direction, damage):
	var pos = get_global_position()
	for i in range(10):
		var blood = BLOODSCENE.instance()
		blood.set_position(pos)
		blood.Direction = direction.angle() + rand_range(-0.1, 0.1)
		blood.Speed = damage * rand_range(0.8, 1.2)
		Global.TopEffectsNode.add_child(blood)
