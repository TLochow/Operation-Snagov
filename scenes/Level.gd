extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("restart"):
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _ready():
	Global.EffectsNode = $Effects
	Global.DebrisNode = $Debris
	GenerateLevel()
	$Rooms/StartRoom.OpenDoors()

func GenerateLevel():
	$Rooms/StartRoom.Type = Default.RoomTypes.Start
	# Generate Rooms
	var roomsNode = $Rooms
	Global.LevelGenBlockedCoords = [Vector2(0, 0)]
	var roomIndex = 0
	var roomsLeftToGenerate = true
	var allRooms = roomsNode.get_children()
	while roomsLeftToGenerate:
		if roomIndex < allRooms.size():
			allRooms[roomIndex].GenerateNeighbors(roomsNode)
			roomIndex += 1
		else:
			allRooms = roomsNode.get_children()
			if roomIndex >= allRooms.size():
				roomsLeftToGenerate = false
	
	# Selecting Special Rooms
	var numberOfRooms = allRooms.size()
	allRooms[numberOfRooms - 1].Type = Default.RoomTypes.Boss
	var placingShop = true
	for room in allRooms:
		if room.GetNumberOfNeighbors() == 1:
			if placingShop:
				room.Type = Default.RoomTypes.Shop
				placingShop = false
			else:
				room.Type = Default.RoomTypes.Item
				break
	
	# Load Layouts
	for room in allRooms:
		room.SetExits()
		room.LoadLayout()
