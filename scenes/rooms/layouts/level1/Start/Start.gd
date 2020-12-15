extends "res://scenes/rooms/layouts/LayoutBase.gd"

func Activate():
	$AnimationPlayer.play("Text")
	emit_signal("Cleared")
