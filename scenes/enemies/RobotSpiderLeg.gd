extends Position2D

export(bool) var LeftSide = false

onready var End = $End
onready var Leg = $Leg

var BasePos
var PreviousPos
var PreviousEndPos

func _ready():
	BasePos = get_global_position()
	PreviousPos = BasePos
	PreviousEndPos = BasePos

func _process(delta):
	BasePos = get_global_position()
	var differenceToBefore = BasePos - PreviousPos
	PreviousPos = BasePos
	var endPos = End.get_global_position() - differenceToBefore
	var newEndPos = to_local(endPos)
	End.set_position(newEndPos)
	Leg.points[1] = newEndPos

func UpdateLegPos():
	var diff = End.get_global_position() - BasePos
	var reposition = abs(diff.x) > 12.0 or abs(diff.x) < 4.0 or abs(diff.y) > 6.0
	if reposition:
		var direction = BasePos - PreviousEndPos
		PreviousEndPos = BasePos
		if LeftSide:
			End.set_position(to_local(BasePos + Vector2(-8.0, 0.0) - (diff * 0.7)))
		else:
			End.set_position(to_local(BasePos + Vector2(8.0, 0.0) - (diff * 0.7)))
