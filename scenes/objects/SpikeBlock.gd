extends KinematicBody2D

export(Default.Directions) var StartDirection
export(bool) var GoingClockwise = true
export(float) var MoveSpeed = 300.0

var Direction

func _ready():
	set_physics_process(false)

func Activate():
	MatchDirection()
	set_physics_process(true)

func MatchDirection():
	match StartDirection:
		Default.Directions.Up:
			Direction = Default.DirUp
		Default.Directions.Down:
			Direction = Default.DirDown
		Default.Directions.Left:
			Direction = Default.DirLeft
		Default.Directions.Right:
			Direction = Default.DirRight

func _physics_process(delta):
	var collision = move_and_collide(Direction * MoveSpeed * delta)
	if collision:
		if collision.collider.has_method("Damage"):
			collision.collider.Damage(1.0, get_global_position() + (Direction * 8.0), Direction, Direction * -1.0)
		if GoingClockwise:
			StartDirection = wrapi(StartDirection + 1, 0, 4)
		else:
			StartDirection = wrapi(StartDirection - 1, 0, 4)
		MatchDirection()
