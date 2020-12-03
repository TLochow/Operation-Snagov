extends Area2D

var LoadNextLevel = false

func Open():
	$AnimationPlayer.play("Open")
	
func Close():
	$AnimationPlayer.play("Close")

func _on_Elevator_body_entered(body):
	$ExitBarrier.set_collision_mask_bit(1, true)
	$LeftDoor.set_collision_layer_bit(0, false)
	$LeftDoor.set_collision_mask_bit(0, false)
	$RightDoor.set_collision_layer_bit(0, false)
	$RightDoor.set_collision_mask_bit(0, false)
	LoadNextLevel = true
	Close()

func _on_AnimationPlayer_animation_finished(anim_name):
	if LoadNextLevel:
		Global.CurrentLevel += 1
		var player = get_tree().get_nodes_in_group("Player")[0]
		Global.PlayerHealth = player.Health
		Global.PlayerMaxHealth = player.MaxHealth
		Global.PlayerGrenades = player.Grenades
		Global.PlayerArmor = player.Armor
		Global.PlayerMoney = player.Money
		
		Global.PlayerShootCooldown = player.ShootCooldown
		Global.PlayerShotSpread = player.ShotSpread
		Global.PlayerShotAmount = player.ShotAmount
		Global.PlayerShotDamage = player.ShotDamage
		
		Global.PlayerImpactDetector = player.ImpactDetector
		Global.PlayerGrenadeLauncher = player.GrenadeLauncher
		Global.PlayerBlastShield = player.BlastShield
		SceneChanger.ChangeScene("res://scenes/Level.tscn")