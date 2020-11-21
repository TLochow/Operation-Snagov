extends KinematicBody2D

onready var AnimPlayer = $AnimationPlayer
var PlayingWalkAnimation = true
onready var PlayerSprite = $Sprite

var LookDirection = Vector2(0.0, 0.0)

func _ready():
	AnimPlayer.play("Walk")

func _physics_process(delta):
	var moveDirection = Vector2(0.0, 0.0)
	if Input.is_action_pressed("ui_left"):
		moveDirection += Vector2(-1.0, 0.0)
	if Input.is_action_pressed("ui_right"):
		moveDirection += Vector2(1.0, 0.0)
	if Input.is_action_pressed("ui_up"):
		moveDirection += Vector2(0.0, -1.0)
	if Input.is_action_pressed("ui_down"):
		moveDirection += Vector2(0.0, 1.0)
	move_and_slide(moveDirection.normalized() * delta * 10000.0, Vector2(0.0, 0.0))
	if moveDirection == Vector2(0.0, 0.0):
		if PlayingWalkAnimation:
			AnimPlayer.stop(false)
			PlayingWalkAnimation = false
	else:
		if not PlayingWalkAnimation:
			AnimPlayer.play()
			PlayingWalkAnimation = true
	
	LookDirection = (.get_global_mouse_position() - get_position()).normalized()
	PlayerSprite.rotation = LookDirection.angle()
