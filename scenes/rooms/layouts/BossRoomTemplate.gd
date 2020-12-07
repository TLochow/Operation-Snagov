extends "res://scenes/rooms/layouts/LayoutBase.gd"

var ITEMSPAWNERSCENE = preload("res://scenes/items/ItemSpawner.tscn")
var Spawner

export(String) var BossName = "BossName"
export(String) var BossDescription = "BossDescription"

var BossMaxHealth = 0.0
var BossHealth = 0.0
onready var Boss = weakref($Enemies.get_children()[0])
onready var BossHealthBar = $CanvasLayer/UI/BossHealth

func _ready():
	var boss = Boss.get_ref()
	BossMaxHealth = boss.Health
	BossHealthBar.max_value = BossMaxHealth
	$CanvasLayer/UI/BossName.text = BossName
	PlaceElevator()
	._ready()

func PlaceElevator():
	var elevatorRotation = 0.0
	var pos
	if RoomOpenTop:
		pos = Vector2(0.0, Default.RoomSize.y - 32.0)
	elif RoomOpenBottom:
		elevatorRotation = PI
		pos = Vector2(0.0, -(Default.RoomSize.y - 32.0))
	elif RoomOpenLeft:
		elevatorRotation = PI * -0.5
		pos = Vector2(Default.RoomSize.x - 32.0, 0.0)
	elif RoomOpenRight:
		elevatorRotation = PI * 0.5
		pos = Vector2(-(Default.RoomSize.x - 32.0), 0.0)
	$Elevator.rotation = elevatorRotation
	$Elevator.set_position(pos * 0.5)

func Activate():
	.Activate()
	Global.emit_signal("Announcement", BossName, BossDescription)

func _process(delta):
	var boss = Boss.get_ref()
	if boss:
		BossHealth = boss.Health
	else:
		var remainingEnemies = $Enemies.get_children()
		if remainingEnemies.size() > 0:
			Boss = weakref(remainingEnemies[0])
		else:
			if Global.CurrentLevel != 0:
				SpawnItem()
			$CanvasLayer/UI.visible = false
			$Elevator.Open()
			emit_signal("Cleared")
			set_process(false)
	BossHealthBar.value = BossHealth

func SpawnItem():
	Spawner = ITEMSPAWNERSCENE.instance()
	add_child(Spawner)
	$Timer.start()

func _on_Timer_timeout():
	Spawner.Activate()
