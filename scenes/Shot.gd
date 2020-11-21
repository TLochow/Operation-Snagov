extends Node2D

var Shot = false
var ShotEnd = Vector2(0.0, 0.0)

var Line

func Shoot(damage, angle):
	Shot = true
	var direction = Vector2(cos(angle), sin(angle))
	var localPos = to_local(get_position())
	Line = $Line2D
	var raycast = $RayCast2D
	raycast.cast_to = direction * 1000.0
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var hitPoint = raycast.get_collision_point()
		ShotEnd = to_local(hitPoint)
		Line.points = [localPos, localPos]
		var collider = raycast.get_collider()
		if collider.has_method("Damage"):
			collider.Damage(damage, hitPoint, direction)
	else:
		ShotEnd = to_local(raycast.cast_to)
		Line.points = [localPos, localPos]
	
	var colorTween = $ColorTween
	colorTween.interpolate_property(Line, "default_color", Color(0.5, 0.5, 0.5, 0.5), Color(0.5, 0.5, 0.5, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	colorTween.start()

func _process(delta):
	if Shot:
		var lineEndPos = Line.points[1]
		var maxLength = ShotEnd.distance_to(lineEndPos)
		lineEndPos += (ShotEnd - lineEndPos).normalized() * min(delta * 7000.0, maxLength)
		Line.points[1] = lineEndPos

func _on_ColorTween_tween_all_completed():
	queue_free()
