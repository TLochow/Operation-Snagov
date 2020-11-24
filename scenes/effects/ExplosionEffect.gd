extends Particles2D

onready var Smoke = $Smoke

func _ready():
	emitting = true
	Smoke.emitting = true

func _process(delta):
	if not Smoke.emitting:
		queue_free()
