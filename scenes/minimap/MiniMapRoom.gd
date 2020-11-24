extends Node2D

var Room

func _ready():
	Room.connect("Discovered", self, "RoomDiscovered")

func GetFileName():
	var fileName = "res://graphics/UI/minimap/open"
	if Room.OpenTop:
		fileName += "u"
	if Room.OpenRight:
		fileName += "r"
	if Room.OpenBottom:
		fileName += "d"
	if Room.OpenLeft:
		fileName += "l"
	fileName += ".png"
	return fileName

func RoomDiscovered():
	var spriteNode = $RoomSprite
	spriteNode.texture = load(GetFileName())
	$UndiscoveredSprite.queue_free()
