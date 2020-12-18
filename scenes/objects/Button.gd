extends Area2D

signal Pressed
signal Released

var Pressed = false
var Count = 0
export(bool) var OneTimePress = false

func _on_Button_body_entered(body):
	Count += 1
	if not OneTimePress or not Pressed:
		emit_signal("Pressed")
		$Sprite.frame = 1
	Pressed = Count > 0

func _on_Button_body_exited(body):
	Count -= 1
	if not OneTimePress:
		Pressed = Count > 0
		if not Pressed:
			emit_signal("Released")
			$Sprite.frame = 0
