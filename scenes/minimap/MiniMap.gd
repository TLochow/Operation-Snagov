extends Viewport

var ROOMSCENE = preload("res://scenes/minimap/MiniMapRoom.tscn")

onready var MapCamera = $Camera2D
var RoomSize = Vector2(10.0, 6.0)

func RegisterRoom(room):
	var mapRoom = ROOMSCENE.instance()
	mapRoom.set_position(room.GenerationCoords * RoomSize)
	mapRoom.Room = room
	$Rooms.add_child(mapRoom)

func ChangedRoom(dir):
	MapCamera.position += dir * RoomSize
