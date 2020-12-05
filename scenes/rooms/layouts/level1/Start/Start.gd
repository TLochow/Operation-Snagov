extends "res://scenes/rooms/layouts/LayoutBase.gd"

func _on_Button_Pressed():
	emit_signal("Cleared")
