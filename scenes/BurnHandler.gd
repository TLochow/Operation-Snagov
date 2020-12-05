extends Node2D

onready var Parent = get_parent()

func _ready():
	var tween = $BlackTween
	tween.interpolate_property(Parent, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 1.0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_BlackTween_tween_all_completed():
	var tween = $TransparentTween
	tween.interpolate_property(Parent, "modulate", Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.0, 0.0, 0.0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_TransparentTween_tween_all_completed():
	Parent.call_deferred("queue_free")
