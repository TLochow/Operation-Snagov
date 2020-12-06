extends "res://scenes/enemies/_EnemyBase.gd"

onready var VerticalCast = $VerticalCast
onready var HorizontalCast = $HorizontalCast

var Legs = []
var LegToUpdate = 0
var MovingUp
var MovingLeft

func _ready():
	Legs = $Legs.get_children()
	MovingUp = randi() % 2 == 0
	MovingLeft = randi() % 2 == 0
	SetCastPositions()

func _physics_process(delta):
	var dir = Default.DirCenter
	if MovingLeft:
		dir += Default.DirLeft
	else:
		dir += Default.DirRight
	if MovingUp:
		dir += Default.DirUp
	else:
		dir += Default.DirDown
	
	move_and_slide(dir.normalized() * 50.0)
	
	if HorizontalCast.is_colliding():
		MovingLeft = not MovingLeft
		SetCastPositions()
	if VerticalCast.is_colliding():
		MovingUp = not MovingUp
		SetCastPositions()
	
	Legs[LegToUpdate].UpdateLegPos()
	LegToUpdate = wrapi(LegToUpdate + 1, 0, 8)

func SetCastPositions():
	var length = 10.0
	if MovingLeft:
		HorizontalCast.cast_to = Default.DirLeft * length
	else:
		HorizontalCast.cast_to = Default.DirRight * length
	if MovingUp:
		VerticalCast.cast_to = Default.DirUp * length
	else:
		VerticalCast.cast_to = Default.DirDown * length

func _on_PlayerDetector_body_entered(body):
	var pos =  get_global_position()
	var toPlayer = body.get_position() - pos
	body.Damage(1.0, pos + (toPlayer * 0.5), toPlayer, toPlayer * -1.0)
