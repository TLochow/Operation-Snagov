extends RigidBody2D

var Type

func _ready():
	$AnimationPlayer.play("Blink")
	$Sprite.frame = int(Type)
	$GlowSprite.frame = int(Type)

func _on_PlayerDetection_body_entered(body):
	match Type:
		Default.PickupTypes.Health:
			if body.Health < body.MaxHealth:
				body.Health += 1
				call_deferred("queue_free")
		Default.PickupTypes.Grenade:
			body.Grenades += 1
			call_deferred("queue_free")
		Default.PickupTypes.Key:
			body.Keys += 1
			call_deferred("queue_free")
		Default.PickupTypes.Money:
			body.Money += 1
			call_deferred("queue_free")

func Explode(pos, strength):
	linear_velocity += (get_position() - pos).normalized() * strength * 3000.0
