extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _ready():
	GenerateLevel()

func GenerateLevel():
	var roomsNode = $Rooms
	Global.LevelGenBlockedCoords = [Vector2(0, 0)]
	var roomsLeftToGenerate = true
	while roomsLeftToGenerate:
		var roomsToGenerate = []
		var allRooms = roomsNode.get_children()
		for room in allRooms:
			if not room.GeneratedNeighbors:
				roomsToGenerate.append(room)
		if roomsToGenerate.size() == 0:
			roomsLeftToGenerate = false
		else:
			for room in roomsToGenerate:
				room.GenerateNeighbors(roomsNode)
	var allRooms = roomsNode.get_children()
	print(allRooms.size())
	for room in allRooms:
		room.SetExits()
	$Rooms/StartRoom.OpenDoors()
