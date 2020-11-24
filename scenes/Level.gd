extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("restart"):
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _ready():
	Global.TopEffectsNode = $TopEffects
	Global.DebrisNode = $Debris
	GenerateLevel()
	PrepareBloodSprite()
	$Rooms/StartRoom.OpenDoors()
	
	var player = $Player
	player.connect("HealthChanged", self, "PlayerHealthChanged")
	player.connect("GrenadesChanged", self, "PlayerGrenadesChanged")
	player.connect("KeysChanged", self, "PlayerKeysChanged")
	player.connect("MoneyChanged", self, "PlayerMoneyChanged")

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

func PrepareBloodSprite():
	var minX = 1000.0
	var minY = 1000.0
	var maxX = -1000.0
	var maxY = -1000.0
	for coord in Global.LevelGenBlockedCoords:
		minX = min(minX, coord.x)
		minY = min(minY, coord.y)
		maxX = max(maxX, coord.x)
		maxY = max(maxY, coord.y)
	var spriteSize = ((Vector2(max(-minX, maxX), max(-minY, maxY)) * Default.RoomSize) * 2.0) + Default.RoomSize
	Global.BloodHandler = $BloodHandler
	Global.BloodHandler.PrepareBloodSprite(spriteSize)

func PlayerHealthChanged(health, maxHealth):
	$UI/Health.text = str(health) + "/" + str(maxHealth)

func PlayerGrenadesChanged(grenades):
	$UI/Grenades.text = str(grenades)

func PlayerKeysChanged(keys):
	$UI/Keys.text = str(keys)

func PlayerMoneyChanged(money):
	$UI/Money.text = str(money)
