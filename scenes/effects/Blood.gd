extends Node2D

var Direction = 0.0
var Speed = 1.0
var EndPos

func _ready():
	var raycast = $RayCast2D
	var heading = Vector2(cos(Direction), sin(Direction))
	var target = heading * 1000.0
	raycast.cast_to = target
	raycast.force_raycast_update()
	if raycast.is_colliding():
		target = to_local(raycast.get_collision_point())
	var maxLength = Speed * rand_range(0.0, 50.0)
	if target.length() > maxLength:
		target = target.normalized() * maxLength
	var tween = $Tween
	EndPos = to_global(target)
	tween.interpolate_property(self, "position", get_position(), EndPos, 0.1 + rand_range(0.0, 0.1), Tween.TRANS_LINEAR)
	tween.start()

func _on_Tween_tween_all_completed():
	Global.BloodHandler.RegisterBlood(self)
