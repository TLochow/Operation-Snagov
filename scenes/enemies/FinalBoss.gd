extends "res://scenes/enemies/_EnemyBase.gd"

var SHOTSCENE = preload("res://scenes/shots/Shot.tscn")
var FIRESCENE = preload("res://scenes/shots/Fire.tscn")
var GRENADESCENE = preload("res://scenes/shots/Grenade.tscn")
var DRONESCENE = preload("res://scenes/enemies/SmallDrone.tscn")

onready var Player = get_tree().get_nodes_in_group("Player")[0]
onready var VerticalCast = $CollsionRays/Vertical
onready var HorizontalCast = $CollsionRays/Horizontal
onready var SpriteNode = $Sprite
onready var PilotSprite = $Pilot
onready var Ring = $Ring
onready var PhaseTween = $PhaseTween
onready var PhaseTimer = $PhaseTimer
onready var PhaseAnimationPlayer = $PhaseAnimationPlayer
onready var EnemiesNode = get_parent()
onready var ShotNode = get_tree().get_nodes_in_group("ShotsNode")[0]

var DamageRays
var ShootingPoints

var MovingUp
var MovingLeft

var RotationSpeed = 0.0
var MoveSpeed = 0.0
var PhasePart = PhaseParts.Startup
var CurrentPhase = Phases.Startup
onready var NumberOfPhases = Phases.values().size() - 2

enum PhaseParts {
	Startup,
	Execution,
	WindDown,
	FreeMove
}

enum Phases {
	Startup,
	StandStillShoot,
	SlowMoveShoot,
	Fire,
	Grenades,
	Drones,
	FastMovement,
	MoveToPlayer
}

func _ready():
	MovingUp = randi() % 2 == 0
	MovingLeft = randi() % 2 == 0
	SetCastPositions()
	DamageRays = $Ring/DamageRays.get_children()
	ShootingPoints = $Ring/ShootingPoints.get_children()
	._ready()

func Activate():
	var dirToPlayer = Player.get_position() - get_global_position()
	SpriteNode.rotation = dirToPlayer.angle()
	PilotSprite.rotation = SpriteNode.rotation
	.Activate()

func _physics_process(delta):
	var dir = Default.DirCenter
	if MovingLeft:
		dir += Default.DirLeft
	else:
		dir += Default.DirRight
	if MovingUp:
		dir += Default.DirUp
	else:
		dir += Default.DirDown
	move_and_slide(dir.normalized() * MoveSpeed)
	
	if HorizontalCast.is_colliding():
		MovingLeft = not MovingLeft
		SetCastPositions()
	if VerticalCast.is_colliding():
		MovingUp = not MovingUp
		SetCastPositions()
	
	Ring.rotation = wrapf(Ring.rotation + (delta * RotationSpeed), -PI, PI)
	DamageByRays()
	
	var dirToPlayer = Player.get_position() - get_global_position()
	SpriteNode.rotation = lerp_angle(SpriteNode.rotation, dirToPlayer.angle(), 0.1)
	PilotSprite.rotation = SpriteNode.rotation

func DamageByRays():
	for ray in DamageRays:
		if ray.is_colliding():
			var hitPoint = ray.get_collision_point()
			var collider = ray.get_collider()
			if collider.has_method("Damage"):
				collider.Damage(1.0, hitPoint, ray.cast_to.rotated(Ring.rotation).normalized(), ray.get_collision_normal())

func SetCastPositions():
	var length = 25.0
	if MovingLeft:
		HorizontalCast.cast_to = Default.DirLeft * length
	else:
		HorizontalCast.cast_to = Default.DirRight * length
	if MovingUp:
		VerticalCast.cast_to = Default.DirUp * length
	else:
		VerticalCast.cast_to = Default.DirDown * length

func PhaseStep():
	match CurrentPhase:
		Phases.Startup:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", 0.0, 5.0, 3.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseTween.interpolate_property(self, "MoveSpeed", 0.0, 50.0, 3.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.WindDown:
					PhaseTimer.start()
		Phases.StandStillShoot:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 0.2, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 0.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseAnimationPlayer.play("StandStillShoot")
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
		Phases.SlowMoveShoot:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 1.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 10.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseAnimationPlayer.play("SlowMoveShoot")
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
		Phases.Fire:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 10.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 0.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseAnimationPlayer.play("Fire")
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
		Phases.Grenades:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, -2.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 0.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseAnimationPlayer.play("Grenades")
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
		Phases.Drones:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, -5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 20.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseAnimationPlayer.play("Drones")
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "RotationSpeed", RotationSpeed, 5.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
		Phases.FastMovement:
			match PhasePart:
				PhaseParts.Startup:
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 200.0, 4.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
				PhaseParts.Execution:
					PhaseTimer.wait_time = 5.0
					PhaseTimer.start()
				PhaseParts.WindDown:
					PhaseTween.interpolate_property(self, "MoveSpeed", MoveSpeed, 50.0, 4.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
					PhaseTween.start()
	if PhasePart == PhaseParts.FreeMove:
		RandomNextPhase()
		PhaseTimer.wait_time = rand_range(5.0, 10.0)
		PhaseTimer.start()
	PhasePart = wrapi(PhasePart + 1, 0, 4)

func _on_PhaseAnimationPlayer_animation_finished(anim_name):
	PhaseStep()

func RandomNextPhase():
	var before = CurrentPhase
	var new = before
	while new == before:
		new = (randi() % NumberOfPhases) + 1
	CurrentPhase = new

func Shoot(number):
	var pos = ShootingPoints[number].get_global_position()
	var dir = (pos - get_global_position()).normalized()
	var shot = SHOTSCENE.instance()
	ShotNode.add_child(shot)
	shot.set_position(pos)
	shot.Shoot(1.0, dir.angle())
	
func Fire(number):
	var pos = ShootingPoints[number].get_global_position()
	var dir = (pos - get_global_position()).normalized()
	var fire = FIRESCENE.instance()
	fire.set_position(pos)
	fire.linear_velocity = dir * 500.0
	ShotNode.call_deferred("add_child", fire)

func Grenade(number):
	var pos = ShootingPoints[number].get_global_position()
	var dir = (pos - get_global_position()).normalized()
	var grenade = GRENADESCENE.instance()
	grenade.set_position(pos)
	grenade.linear_velocity = dir * 500.0
	grenade.angular_velocity = rand_range(-10.0, 10.0)
	ShotNode.call_deferred("add_child", grenade)

func Drone(number):
	var pos = ShootingPoints[number].get_global_position()
	var dir = (pos - get_global_position()).normalized()
	var grenade = GRENADESCENE.instance()
	var drone = DRONESCENE.instance()
	drone.set_position(pos)
	drone.linear_velocity = dir * 500.0
	EnemiesNode.call_deferred("add_child", drone)
