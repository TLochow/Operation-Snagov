extends Node2D

var OpenTop
var OpenBottom
var OpenLeft
var OpenRight

func Configure(openTop, openBottom, openLeft, openRight):
	OpenTop = openTop
	OpenBottom = openBottom
	OpenLeft = openLeft
	OpenRight = openRight
	if OpenTop:
		$Doors/TopWall.queue_free()
	else:
		$Doors/Top.queue_free()
	if OpenBottom:
		$Doors/BottomWall.queue_free()
	else:
		$Doors/Bottom.queue_free()
	if OpenLeft:
		$Doors/LeftWall.queue_free()
	else:
		$Doors/Left.queue_free()
	if OpenRight:
		$Doors/RightWall.queue_free()
	else:
		$Doors/Right.queue_free()
