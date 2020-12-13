extends "res://scenes/rooms/layouts/LayoutBase.gd"

onready var Turret = $FireTurret

var Movement = 0.0

func Activate():
	if randi() % 2 == 0:
		Movement = 1.0
	else:
		Movement = -1.0
	$FireTurret/Turret.Armed = true
	$FireTurret/Turret2.Armed = true
	$FireTurret/Turret3.Armed = true
	$FireTurret/Turret4.Armed = true
	.Activate()

func _process(delta):
	Turret.rotation = wrapf(Turret.rotation + (Movement * delta), -PI, PI)

func _on_FireSpin_Cleared():
	$FireTurret/Turret.Armed = false
	$FireTurret/Turret2.Armed = false
	$FireTurret/Turret3.Armed = false
	$FireTurret/Turret4.Armed = false
