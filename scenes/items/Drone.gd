extends KinematicBody2D

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

var Targets = []

var ShootCooldownCounter = 0.0

func _physics_process(delta):
	var pos = get_global_position()
	var dirToPlayer = Player.get_position() - pos
	var moveSpeed = max(dirToPlayer.length(), 24.0) - 24.0
	move_and_slide(dirToPlayer.normalized() * moveSpeed)
	
	var targeting = false
	var targetPos
	var bestDist = 999999999.0
	for target in Targets:
		if target.Active:
			targeting = true
			var thisPos = target.get_global_position()
			var dist = thisPos.distance_to(pos)
			if dist < bestDist:
				bestDist = dist
				targetPos = thisPos
	
	ShootCooldownCounter -= delta
	if targeting:
		rotation = lerp_angle(rotation, (targetPos - pos).angle(), 0.1)
		if ShootCooldownCounter <= 0.0:
			Shoot(pos)
	else:
		rotation = lerp_angle(rotation, dirToPlayer.angle(), 0.01)
		
func Shoot(pos):
	ShootCooldownCounter = Player.ShootCooldown
	var direction = Vector2(cos(rotation), sin(rotation))
	var shootPos = pos + (direction * 6.0)
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(shootPos)
	shot.Shoot(Player.ShotDamage, rotation + rand_range(-Player.ShotSpread, Player.ShotSpread), true)

func _on_TargetDetection_body_entered(body):
	Targets.append(body)

func _on_TargetDetection_body_exited(body):
	Targets.erase(body)
