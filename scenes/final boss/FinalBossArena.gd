extends Node2D

var SPAWNEFFECTSCENE = preload("res://scenes/effects/Spawning.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var Boss = $Enemies.get_children()[0]

onready var BurningDebrisNode = $BurningDebris
onready var WallsNode = $DesctrutibleWalls
onready var EnemyNode = $Enemies
onready var FurnitureNode = $Furniture
onready var BurnTimer = $BurnFurnitureTimer
onready var HealthBar = $UI/Health


var Furniture = []
var FurnitureSize

func _ready():
	LoadFurniture()
	Global.emit_signal("Announcement", "Nicolae Ceausescu", "Time for Payback")
	HealthBar.max_value = Boss.Health

func LoadFurniture():
	var basePath = "res://scenes/objects/furniture"
	var paths = Global.GetAllFilesFromDirectory(basePath)
	for path in paths:
		if path.ends_with(".tscn") and path != "LargeTable.tscn":
			Furniture.append(load(basePath + "/" + path))
	FurnitureSize = Furniture.size()

func _process(delta):
	var enemies = EnemyNode.get_children()
	for enemy in enemies:
		if not enemy.Active:
			enemy.Activate()
	
	if Global.DebrisNode.get_child_count() > 200:
		var debris = Global.DebrisNode.get_children()[0]
		Global.ReparentNode(debris, BurningDebrisNode)
	var burningDebris = BurningDebrisNode.get_children()
	for current in burningDebris:
		current.Burn(1000.0)
	
	HealthBar.value = Boss.Health

func _on_SpawnFurnitureTimer_timeout():
	var blockedPos = []
	blockedPos.append(Player.get_position())
	var enemies = EnemyNode.get_children()
	for enemy in enemies:
		blockedPos.append(enemy.get_position())
	var walls = WallsNode.get_children()
	for wall in walls:
		blockedPos.append(wall.get_position())
	for i in range(32.0):
		blockedPos = PlaceRandomFurniture(blockedPos)
	BurnTimer.start()

func PlaceRandomFurniture(blockedPos):
	var furniture = Furniture[randi() % FurnitureSize].instance()
	var pos
	var validPos = false
	while not validPos:
		pos = Vector2(rand_range(-720.0, 720.0), rand_range(-336.0, 336.0))
		validPos = true
		for block in blockedPos:
			if block.distance_to(pos) < 64.0:
				validPos = false
				break
	blockedPos.append(pos)
	furniture.set_position(pos)
	furniture.rotation = rand_range(-PI, PI)
	FurnitureNode.call_deferred("add_child", furniture)
	var spawnEffect = SPAWNEFFECTSCENE.instance()
	spawnEffect.set_position(pos)
	Global.TopEffectsNode.add_child(spawnEffect)
	return blockedPos

func _on_BurnFurnitureTimer_timeout():
	var furniture = FurnitureNode.get_children()
	for current in furniture:
		current.Burn(1000.0)
