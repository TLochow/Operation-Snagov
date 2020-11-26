extends Area2D

export(Default.Items) var ItemType = 0
export(String) var Title = ""
export(String) var Description = ""

var Collected = false

func _ready():
	$Sprite.frame = ItemType
	$AnimationPlayer.play("Pulsate")
	$Particles2D.emitting = true
	
func _on_ItemBase_body_entered(body):
	if not Collected:
		Collected = true
		Global.emit_signal("ItemCollected", Title, Description)
		Collect(body)
	$Particles2D.emitting = false
	$Sprite.visible = false
	$Timer.start()

func _on_Timer_timeout():
	call_deferred("queue_free")

func Collect(player):
	pass
