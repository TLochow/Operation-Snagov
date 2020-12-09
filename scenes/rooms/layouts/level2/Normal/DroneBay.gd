extends "res://scenes/rooms/layouts/LayoutBase.gd"

func _ready():
	var doors = $RightSide/Doors.get_children()
	for door in doors:
		door.Close(false)

	doors = $LeftSide/Doors.get_children()
	for door in doors:
		door.Close(false)
	
	._ready()

func _on_RightButton_Pressed():
	var doors = $RightSide/Doors.get_children()
	for door in doors:
		door.Open()

func _on_LeftButton_Pressed():
	var doors = $LeftSide/Doors.get_children()
	for door in doors:
		door.Open()
