extends Node2D

var ANNOUNCEMENTSCENE = preload("res://scenes/Announcement.tscn")
var FINALBOSSARENASCENE = preload("res://scenes/final boss/FinalBossArena.tscn")
var ROOMSCENE = preload("res://scenes/rooms/Room.tscn")

var HealthBefore = 0.0
var ArmorBefore = 0.0

func _init():
	Engine.time_scale = 1.0
	if Global.CurrentLevel == 1:
		Global.LoadDefaults()
		LayoutLoader.Layouts = {}
		ItemLoader.Items = []

func _input(event):
	if Global.IsDebug and event.is_action_pressed("restart"):
		SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _ready():
	get_tree().paused = false
	MusicHandler.Play()
	Global.TopEffectsNode = $TopEffects
	Global.DebrisNode = $Debris
	Global.PickupsNode = $Pickups
	Global.BloodHandler = $BloodHandler
	$GameCamera.connect("ChangedRoom", $UI/Game/ViewportContainer/MiniMap, "ChangedRoom")
	Global.connect("Announcement", self, "Announcement")
	Global.connect("Won", self, "Won")
	
	if Global.CurrentLevel == 3:
		PrepareFinalBoss()
	else:
		GenerateLevel()
		$Rooms/StartRoom.OpenDoors()

func PrepareFinalBoss():
	$Rooms/StartRoom.queue_free()
	$Rooms.add_child(FINALBOSSARENASCENE.instance())
	var minimap = get_tree().get_nodes_in_group("MiniMap")[0]
	for x in range(3):
		for y in range(3):
			var dummyRoom = ROOMSCENE.instance()
			dummyRoom.GenerationCoords = Vector2(x - 1.0, y - 1.0)
			dummyRoom.OpenTop = y > 0.0
			dummyRoom.OpenBottom = y < 2.0
			dummyRoom.OpenLeft = x > 0.0
			dummyRoom.OpenRight = x < 2.0
			minimap.RegisterRoom(dummyRoom)
			dummyRoom.call_deferred("emit_signal", "Discovered")

func GenerateLevel():
	$Rooms/StartRoom.Type = Default.RoomTypes.Start
	# Generate Rooms
	var roomsNode = $Rooms
	Global.LevelGenBlockedCoords = [Vector2(0, 0)]
	if Global.CurrentLevel == 0:
		Global.LevelGenBlockedCoords.append(Vector2(-1.0, 0.0))
		Global.LevelGenBlockedCoords.append(Vector2(4.0, 0.0))
		for i in range(4):
			Global.LevelGenBlockedCoords.append(Vector2(i, -1.0))
			Global.LevelGenBlockedCoords.append(Vector2(i, 1.0))
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
		$UI/Game/Damage/Tween.stop_all()
		$UI/Game/Damage/Tween.interpolate_property($UI/Game/Damage, "color", Color(0.0, 0.0, 0.7, 0.2), Color(0.0, 0.0, 0.7, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Game/Damage/Tween.start()
	ArmorBefore = armor
	$UI/Game/Armor.text = str(stepify(armor, 0.1))

func _on_Player_GrenadesChanged(grenades):
	$UI/Game/Grenades.text = str(grenades)

func _on_Player_HealthChanged(health, maxHealth):
	if health < HealthBefore:
		$UI/Game/Damage/Tween.stop_all()
		$UI/Game/Damage/Tween.interpolate_property($UI/Game/Damage, "color", Color(0.7, 0.0, 0.0, 0.2), Color(0.7, 0.0, 0.0, 0.0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$UI/Game/Damage/Tween.start()
	HealthBefore = health
	$UI/Game/Health.text = str(stepify(health, 0.1)) + "/" + str(maxHealth)

func _on_Player_MoneyChanged(money):
	$UI/Game/Money.text = str(money)

func Won():
	Global.GameOver = true
	StopGame()
	$UI/GameOver/Label.text = "You Won!"
	$UI/GameOver/EnemiesKilledLabel.text = str(Global.KillCounter)
	$UI/GameOver.visible = true

func _on_Player_Died():
	Global.GameOver = true
	StopGame()
	$UI/GameOver/EnemiesKilledLabel.text = str(Global.KillCounter)
	$UI/GameOver.visible = true

func StopGame():
	var tween = $UI/GameOver/GameOverTween
	tween.interpolate_property(Engine, "time_scale", 0.5, 0.1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property($UI/GameOver, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_GameOverTween_tween_all_completed():
	get_tree().paused = true

func _on_GameOverRestart_pressed():
	get_tree().paused = true
	$UI/GameOver/GameOverTween.stop_all()
	Engine.time_scale = 1.0
	var isTutorial = Global.CurrentLevel == 0
	Global.LoadDefaults()
	if isTutorial:
		Global.CurrentLevel = 0
	SceneChanger.ChangeScene("res://scenes/Level.tscn")

func _on_GameOverBack_pressed():
	get_tree().paused = true
	$UI/GameOver/GameOverTween.stop_all()
	Engine.time_scale = 1.0
	SceneChanger.ChangeScene("res://MainMenu.tscn")
