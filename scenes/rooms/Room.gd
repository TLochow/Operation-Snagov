extends Node2D

signal Discovered

var GeneratedNeighbors = false
var DistanceToStart = 0
var GenerationCoords = Vector2(0, 0)

var Type = Default.RoomTypes.Normal

export(bool) var OpenTop = false
export(bool) var OpenBottom = false
export(bool) var OpenLeft = false
export(bool) var OpenRight = false

var Activated = false
var Cleared = false

func _ready():
	get_tree().get_nodes_in_group("MiniMap")[0].RegisterRoom(self)

func ShowBossSprite():
	var bossSprite = $BossSprite
	bossSprite.visible = true
	if OpenTop:
		bossSprite.rotation = PI
		bossSprite.set_position(Vector2(0.0, -((Default.RoomSize.y * 0.5) + 32.0)))
	elif OpenBottom:
		bossSprite.set_position(Vector2(0.0, ((Default.RoomSize.y * 0.5) + 32.0)))
	elif OpenLeft:
		bossSprite.rotation = PI * 0.5
		bossSprite.set_position(Vector2(-((Default.RoomSize.x * 0.5) + 32.0), 0.0))
	elif OpenRight:
		bossSprite.rotation = PI * -0.5
		bossSprite.set_position(Vector2(((Default.RoomSize.x * 0.5) + 32.0), 0.0))

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
	var layout = LayoutLoader.LoadRandomLayout(Global.CurrentLevel, Type)
	layout.RoomOpenTop = OpenTop
	layout.RoomOpenBottom = OpenBottom
	layout.RoomOpenLeft = OpenLeft
	layout.RoomOpenRight = OpenRight
	$Layout.add_child(layout)
	if Type == Default.RoomTypes.Boss:
		ShowBossSprite()
	else:
		$BossSprite.queue_free()

func GenerateNeighbors(roomsNode):
	GeneratedNeighbors = true
	var percentageForRoomGeneration = (1.0 * Global.CurrentLevel) - (DistanceToStart * 0.4)
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
		emit_signal("Discovered")
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
