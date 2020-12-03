extends "res://scenes/rooms/layouts/LayoutBase.gd"

func Activate():
	$AnimationPlayer.play("Open")
	emit_signal("Cleared")
