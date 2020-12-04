extends Particles2D

func _ready():
	SoundEffectHandler.Play(Default.SoundEffects.Explosion)
	emitting = true
	$Smoke.emitting = true

func _on_Timer_timeout():
	queue_free()
