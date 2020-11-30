extends Area2D

signal Pressed
signal Released

var Pressed = false
export(bool) var OneTimePress = false

func _on_Button_body_entered(body):
	if not Pressed:
		Pressed = true
		emit_signal("Pressed")
		$Sprite.frame = 1

func _on_Button_body_exited(body):
	if Pressed and not OneTimePress:
		Pressed = false
		emit_signal("Released")
		$Sprite.frame = 0
