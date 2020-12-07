extends Area2D

var EFFECTSCENE = preload("res://scenes/effects/ExplosionEffect.tscn")

onready var Position = get_position()

func _ready():
	var effect = EFFECTSCENE.instance()
	effect.set_position(Position)
	Global.TopEffectsNode.add_child(effect)

func _on_Explosion_body_entered(body):
	if body.has_method("Explode"):
		body.Explode(Position, 5.0)

func _on_Timer_timeout():
	call_deferred("queue_free")
