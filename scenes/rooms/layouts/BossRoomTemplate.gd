extends "res://scenes/rooms/layouts/LayoutBase.gd"

export(String) var BossName = "BossName"
export(String) var BossDescription = "BossDescription"

var BossMaxHealth = 0.0
var BossHealth = 0.0
onready var Boss = weakref($Enemies.get_children()[0])
onready var BossHealthBar = $UI/BossHealth

func _ready():
	var boss = Boss.get_ref()
	BossMaxHealth = boss.Health
	BossHealthBar.max_value = BossMaxHealth
	$UI/BossName.text = BossName
	._ready()

func Activate():
	.Activate()
	Global.emit_signal("Announcement", BossName, BossDescription)

func _process(delta):
	var boss = Boss.get_ref()
	var healthMod = delta * 2.5
	if boss:
		if BossHealth < boss.Health:
			BossHealth = min(BossHealth + healthMod, boss.Health)
		elif BossHealth > boss.Health:
			BossHealth = max(BossHealth - healthMod, boss.Health)
	else:
		BossHealth = max(BossHealth - healthMod, 0.0)
		if BossHealth == 0.0:
			$UI.visible = false
			emit_signal("Cleared")
			set_process(false)
	BossHealthBar.value = BossHealth
