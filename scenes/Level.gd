extends Node2D

var HealthBefore = 0.0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("restart"):
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _ready():
	Global.TopEffectsNode = $TopEffects
	Global.DebrisNode = $Debris
	Global.BloodHandler = $BloodHandler
	GenerateLevel()
	$Rooms/StartRoom.OpenDoors()
	
	var player = $Player
	player.connect("HealthChanged", self, "PlayerHealthChanged")
	player.connect("GrenadesChanged", self, "PlayerGrenadesChanged")
	player.connect("ArmorChanged", self, "PlayerArmorChanged")
	player.connect("MoneyChanged", self, "PlayerMoneyChanged")
	
	$GameCamera.connect("ChangedRoom", $UI/Game/ViewportContainer/MiniMap, "ChangedRoom")
	
	Global.connect("ItemCollected", self, "ItemCollected")
	
	HealthBefore = player.Health

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
	allRooms[numberOfRooms - 2].Type = Default.RoomTypes.Item
	for room in allRooms:
		if room.GetNumberOfNeighbors() == 1:
			room.Type = Default.RoomTypes.Shop
			break
	
	# Load Layouts
	for room in allRooms:
		room.SetExits()
		room.LoadLayout()

func PlayerHealthChanged(health, maxHealth):
	if health < HealthBefore:
		var intensity = min(0.25 * (HealthBefore - health), 1.0)
		$UI/Game/Damage/Tween.stop_all()
		$UI/Game/Damage/Tween.interpolate_property($UI/Game/Damage, "modulate", Color(1.0, 1.0, 1.0, intensity), Color(1.0, 1.0, 1.0, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Game/Damage/Tween.start()
	HealthBefore = health
	$UI/Game/Health.text = str(health) + "/" + str(maxHealth)

func PlayerGrenadesChanged(grenades):
	$UI/Game/Grenades.text = str(grenades)

func PlayerArmorChanged(armor):
	$UI/Game/Armor.text = str(armor)

func PlayerMoneyChanged(money):
	$UI/Game/Money.text = str(money)

func ItemCollected(title, description):
	$UI/Game/ItemCollected/ColorRect/TitleLabel.text = title
	$UI/Game/ItemCollected/ColorRect/DescriptionLabel.text = description
	$UI/Game/ItemCollected/AnimationPlayer.play("ItemCollected")
