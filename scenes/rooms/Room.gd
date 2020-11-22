extends Node2D

var GeneratedNeighbors = false
var DistanceToStart = 0
var GenerationCoords = Vector2(0, 0)

var Type = Default.RoomTypes.Normal

var OpenTop = false
var OpenBottom = false
var OpenLeft = false
var OpenRight = false

var Activated = false
var Cleared = false

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

func LoadLayout():
	$Layout.add_child(LayoutLoader.LoadRandomLayout(Global.CurrentLevel, Type))

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

func _on_PlayerDetector_body_entered(body):
	if not Activated:
		Activated = true
		$Layout.get_children()[0].connect("Cleared", self, "RoomCleared")
		ActivateNodes($Layout)
	if not Cleared:
		if Type == Default.RoomTypes.Normal or Type == Default.RoomTypes.Boss:
			CloseDoors()
		else:
			Cleared = true

func _on_PlayerDetector_body_exited(body):
	if not Cleared:
		OpenDoors()

func ActivateNodes(startNode):
	var nodes = [startNode]
	for currentNode in nodes:
		if currentNode.has_method("Activate"):
			currentNode.Activate()
		var children = currentNode.get_children()
		for child in children:
			nodes.append(child)

func RoomCleared():
	Cleared = true
	OpenDoors()
