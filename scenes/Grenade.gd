extends RigidBody2D

var EXPLOSIONSCENE = preload("res://scenes/Explosion.tscn")

func _on_Timer_timeout():
	var explosion = EXPLOSIONSCENE.instance()
	explosion.set_position(get_position())
	get_parent().add_child(explosion)
	call_deferred("queue_free")
