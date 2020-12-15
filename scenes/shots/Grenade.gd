extends RigidBody2D

var EXPLOSIONSCENE = preload("res://scenes/shots/Explosion.tscn")

var Exploded = false
var ExplodeOnContact = false

func _on_Timer_timeout():
	Explode(null, null)

func _on_Grenade_body_entered(body):
	if ExplodeOnContact:
		Explode(null, null)
	else:
		$Bounce.play()

func Explode(pos, strength):
	if not Exploded:
		Exploded = true
		var explosion = EXPLOSIONSCENE.instance()
		explosion.set_position(get_position())
		get_parent().call_deferred("add_child", explosion)
		call_deferred("queue_free")
