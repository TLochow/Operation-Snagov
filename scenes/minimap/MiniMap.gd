extends Node2D

var ROOMSCENE = preload("res://scenes/minimap/MiniMapRoom.tscn")

func RegisterRoom(room):
	var mapRoom = ROOMSCENE.instance()
	mapRoom.set_position(room.GenerationCoords * Vector2(5.0, 3.0))
	mapRoom.Room = room
	$Rooms.add_child(mapRoom)
