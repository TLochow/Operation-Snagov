extends Node2D

var GeneratedNeighbors = false
var DistanceToStart = 0
var GenerationCoords = Vector2(0, 0)

var Type = Default.RoomTypes.Normal

var OpenTop = false
var OpenBottom = false
var OpenLeft = false
var OpenRight = false

func _process(delta):
	var brightness = 1.0 - (DistanceToStart * 0.1)
	var color = Color.white
	if Type == Default.RoomTypes.Boss:
		color = Color.red
	elif Type == Default.RoomTypes.Item:
		color = Color.green
	elif Type == Default.RoomTypes.Shop:
		color = Color.blue
	color *= brightness
	$TileMap.modulate = color
	$Label.text = str(DistanceToStart)

func SetExits():
	if OpenTop:
		$Doors/TopWall.queue_free()
	else:
		$Doors/Top.queue_free()
	if OpenBottom:
		$Doors/BottomWall.queue_free()
	else:
		$Doors/Bottom.queue_free()
	if OpenLeft:
		$Doors/LeftWall.queue_free()
	else:
		$Doors/Left.queue_free()
	if OpenRight:
		$Doors/RightWall.queue_free()
	else:
		$Doors/Right.queue_free()

func GenerateNeighbors(roomsNode):
	GeneratedNeighbors = true
	var percentageForRoomGeneration = 1.0 - (DistanceToStart * 0.4)
	var generateRoomUp = randf() < percentageForRoomGeneration
	var generateRoomDown = randf() < percentageForRoomGeneration
	var generateRoomLeft = randf() < percentageForRoomGeneration
	var generateRoomRight = randf() < percentageForRoomGeneration
	
	if generateRoomUp:
		var newRoomCoord = GenerationCoords + Default.DirUp
		if not Global.LevelGenBlockedCoords.has(newRoomCoord):
			GenerateNewRoom(newRoomCoord, Default.DirUp, roomsNode)
			OpenDoorByDirection(Default.DirUp)
	if generateRoomDown:
		var newRoomCoord = GenerationCoords + Default.DirDown
		if not Global.LevelGenBlockedCoords.has(newRoomCoord):
			GenerateNewRoom(newRoomCoord, Default.DirDown, roomsNode)
			OpenDoorByDirection(Default.DirDown)
	if generateRoomLeft:
		var newRoomCoord = GenerationCoords + Default.DirLeft
		if not Global.LevelGenBlockedCoords.has(newRoomCoord):
			GenerateNewRoom(newRoomCoord, Default.DirLeft, roomsNode)
			OpenDoorByDirection(Default.DirLeft)
	if generateRoomRight:
		var newRoomCoord = GenerationCoords + Default.DirRight
		if not Global.LevelGenBlockedCoords.has(newRoomCoord):
			GenerateNewRoom(newRoomCoord, Default.DirRight, roomsNode)
			OpenDoorByDirection(Default.DirRight)

func OpenDoorByDirection(direction):
	if direction == Default.DirUp:
		OpenTop = true
	elif direction == Default.DirDown:
		OpenBottom = true
	elif direction == Default.DirLeft:
		OpenLeft = true
	elif direction == Default.DirRight:
		OpenRight = true

func GenerateNewRoom(coords, direction, roomsNode):
	Global.LevelGenBlockedCoords.append(coords)
	var newRoom = Global.ROOMSCENE.instance()
	newRoom.GenerationCoords = coords
	newRoom.DistanceToStart = DistanceToStart + 1
	newRoom.OpenDoorByDirection(direction * -1.0)
	newRoom.set_position(coords * Default.RoomSize)
	roomsNode.add_child(newRoom)

func GetNumberOfNeighbors():
	return int(OpenTop) + int(OpenBottom) + int(OpenLeft) + int(OpenRight)

func OpenDoors():
	if OpenTop:
		$Doors/Top.Open()
	if OpenBottom:
		$Doors/Bottom.Open()
	if OpenLeft:
		$Doors/Left.Open()
	if OpenRight:
		$Doors/Right.Open()

func CloseDoors():
	if OpenTop:
		$Doors/Top.Close()
	if OpenBottom:
		$Doors/Bottom.Close()
	if OpenLeft:
		$Doors/Left.Close()
	if OpenRight:
		$Doors/Right.Close()
