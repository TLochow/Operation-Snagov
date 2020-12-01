extends Node2D

var ANNOUNCEMENTSCENE = preload("res://scenes/Announcement.tscn")

var HealthBefore = 0.0
var ArmorBefore = 0.0

func _init():
	if Global.CurrentLevel == 1:
		Global.LoadDefaults()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("restart"):
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _ready():
	MusicHandler.Play()
	Global.TopEffectsNode = $TopEffects
	Global.DebrisNode = $Debris
	Global.BloodHandler = $BloodHandler
	GenerateLevel()
	$Rooms/StartRoom.OpenDoors()
	
	$GameCamera.connect("ChangedRoom", $UI/Game/ViewportContainer/MiniMap, "ChangedRoom")
	
	Global.connect("Announcement", self, "Announcement")

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

func Announcement(title, description):
	var announcement = ANNOUNCEMENTSCENE.instance()
	announcement.Title = title
	announcement.Description = description
	$UI/Game/Announcement.add_child(announcement)

func _on_Player_ArmorChanged(armor):
	if armor < ArmorBefore:
		var intensity = min(0.25 * (ArmorBefore - armor), 1.0)
		$UI/Game/Damage/Tween.stop_all()
		$UI/Game/Damage/Tween.interpolate_property($UI/Game/Damage, "color", Color(0.0, 0.0, 0.7, intensity), Color(0.0, 0.0, 0.7, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Game/Damage/Tween.start()
	ArmorBefore = armor
	$UI/Game/Armor.text = str(armor)

func _on_Player_GrenadesChanged(grenades):
	$UI/Game/Grenades.text = str(grenades)

func _on_Player_HealthChanged(health, maxHealth):
	if health < HealthBefore:
		var intensity = min(0.25 * (HealthBefore - health), 1.0)
		$UI/Game/Damage/Tween.stop_all()
		$UI/Game/Damage/Tween.interpolate_property($UI/Game/Damage, "color", Color(0.7, 0.0, 0.0, intensity), Color(0.7, 0.0, 0.0, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Game/Damage/Tween.start()
	HealthBefore = health
	$UI/Game/Health.text = str(health) + "/" + str(maxHealth)

func _on_Player_MoneyChanged(money):
	$UI/Game/Money.text = str(money)
