extends RigidBody2D

var EXPLOSIONSCENE = preload("res://scenes/Explosion.tscn")

var ExplodeOnContact = false

func _ready():
	if ExplodeOnContact:
		contact_monitor = true
		contacts_reported = 1

func _on_Timer_timeout():
	Explode(null, null)

func _on_Grenade_body_entered(body):
	if ExplodeOnContact:
		Explode(null, null)

func Explode(pos, strength):
	var explosion = EXPLOSIONSCENE.instance()
	explosion.set_position(get_position())
	get_parent().call_deferred("add_child", explosion)
	call_deferred("queue_free")
