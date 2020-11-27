extends Area2D

export(int) var Cost = 0

var Opened = false

func _ready():
	$Door.Close(false)
	$PriceSprite.rotation = -rotation
	$PriceSprite/Label.text = str(Cost)

func _on_PayDoor_body_entered(body):
	if not Opened:
		if body.Money >= Cost:
			Opened = true
			body.Money -= Cost
			$Door.Open()
			$PriceSprite.queue_free()
