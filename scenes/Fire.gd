extends RigidBody2D

onready var SpriteNode = $Sprite

var Objects = []

func _ready():
	$AnimationPlayer.play("Burn")
	FireLimiter.RegisterFire(self)

func _process(delta):
	SpriteNode.rotation = -rotation
	
	for object in Objects:
		object.Burn(0.01)

func _on_AnimationPlayer_animation_finished(anim_name):
	set_process(false)
	$Smoke.emitting = false
	$Timer.start()

func _on_BurnRadius_body_entered(body):
	if body.has_method("Burn"):
		Objects.append(body)

func _on_BurnRadius_body_exited(body):
	Objects.erase(body)

func _on_Timer_timeout():
	call_deferred("queue_free")
