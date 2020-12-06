extends "res://scenes/rooms/layouts/LayoutBase.gd"

func _ready():
	var doors = $Doors.get_children()
	for door in doors:
		door.Close(false)

func _on_Button_Pressed():
	var doors = $Doors.get_children()
	for door in doors:
		door.Open()
