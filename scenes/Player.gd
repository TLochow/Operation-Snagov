extends KinematicBody2D

var SHOTSCENE = preload("res://scenes/Shot.tscn")

onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

onready var AnimPlayer = $AnimationPlayer
var PlayingWalkAnimation = true
onready var PlayerSprite = $Sprite

var LookDirection = Vector2(0.0, 0.0)

var ShootCooldownTime = 0.5
var ShootCooldown = 0.0
var ShotSpread = 0.1
var ShotAmount = 1.0
var ShotDamage = 1.0

func _ready():
	AnimPlayer.play("Walk")

func _physics_process(delta):
	var moveDirection = Default.DirCenter
	if Input.is_action_pressed("ui_left"):
		moveDirection += Default.DirLeft
	if Input.is_action_pressed("ui_right"):
		moveDirection += Default.DirRight
	if Input.is_action_pressed("ui_up"):
		moveDirection += Default.DirUp
	if Input.is_action_pressed("ui_down"):
		moveDirection += Default.DirDown
	move_and_slide(moveDirection.normalized() * delta * 10000.0, Default.DirCenter)
	if moveDirection == Default.DirCenter:
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
	
	ShootCooldown -= delta
	if Input.is_action_pressed("mouse_left") and ShootCooldown <= 0.0:
		var shootPos = pos + (LookDirection * 6.0)
		Shoot(lookAngle, shootPos)

func Shoot(angle, pos):
	ShootCooldown = ShootCooldownTime
	for i in range(ShotAmount):
		var shot = SHOTSCENE.instance()
		ShotNode.add_child(shot)
		shot.set_position(pos)
		shot.Shoot(ShotDamage, angle + rand_range(-ShotSpread, ShotSpread))
