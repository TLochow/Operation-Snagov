extends Area2D

var ItemType = 0
var Title = ""
var Description = ""

var Collected = false

func _ready():
	$Sprite.frame = ItemType
	$AnimationPlayer.play("Pulsate")
	$Particles2D.emitting = true
	SetNameAndDescription()

func _on_ItemBase_body_entered(body):
	if not Collected:
		Collected = true
		Global.emit_signal("Announcement", Title, Description)
		Collect(body)
	$Particles2D.emitting = false
	$Sprite.visible = false
	$Timer.start()

func _on_Timer_timeout():
	call_deferred("queue_free")

func SetNameAndDescription():
	match ItemType:
		Default.Items.Pistol:
			Title = "Pistol"
			Description = "Damage Up"
		Default.Items.DualWield:
			Title = "Dual Wield"
			Description = "Shot Amount X 2"
		Default.Items.Shotgun:
			Title = "Shotgun"
			Description = "Shoot Speed Down - Shoot Spread Up - Shot Amount X 8"
		Default.Items.MachineGun:
			Title = "Machine Gun"
			Description = "Shoot Speed Up"
		Default.Items.BagOfGrenades:
			Title = "Bag Of Grenades"
			Description = "99 Grenades"
		Default.Items.HeartyMeal:
			Title = "Hearty Meal"
			Description = "Max HP Up"
		Default.Items.FirstAidKit:
			Title = "First Aid Kit"
			Description = "Max HP Slightly Up - Full Health"
		Default.Items.GlassPistol:
			Title = "Glass Pistol"
			Description = "Max Health Way Down - Damage Way Up"
		Default.Items.ImpactDetector:
			Title = "Impact Detector"
			Description = "Grenades Explode on Contact"
		Default.Items.GrenadeLauncher:
			Title = "Grenade Launcher"
			Description = "Shoot Grenades - Shot Grenades Explode on Contact"
		Default.Items.BlastShield:
			Title = "Blast Shield"
			Description = "Immune to Explosions"
		Default.Items.SniperRifle:
			Title = "Sniper Rifle"
			Description = "Shoot Speed Down - Accuracy Up - Damage Up"

func Collect(player):
	match ItemType:
		Default.Items.Pistol:
			player.ShotDamage += 1.0
		Default.Items.DualWield:
			player.ShotAmount *= 2.0
		Default.Items.Shotgun:
			player.ShootCooldown *= 2.0
			player.ShotSpread *= 2.0
			player.ShotAmount *= 8.0
		Default.Items.MachineGun:
			player.ShootCooldown *= 0.15
		Default.Items.BagOfGrenades:
			player.Grenades = 99
		Default.Items.HeartyMeal:
			player.MaxHealth += 4.0
			player.Health += 4.0
		Default.Items.FirstAidKit:
			player.MaxHealth += 2.0
			player.Health = player.MaxHealth
		Default.Items.GlassPistol:
			player.MaxHealth = min(player.MaxHealth, 4.0)
			player.ShotDamage *= 10.0
			player.ShotSpread = 0.0
		Default.Items.ImpactDetector:
			player.ImpactDetector = true
		Default.Items.GrenadeLauncher:
			player.GrenadeLauncher = true
		Default.Items.BlastShield:
			player.BlastShield = true
		Default.Items.SniperRifle:
			player.ShotSpread = 0.0
			player.ShootCooldown *= 2.5
			player.ShotDamage *= 4.0
