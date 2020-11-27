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
	match Room.Type:
		Default.RoomTypes.Shop:
			spriteNode.modulate = Color(0.85, 0.75, 0.4, 1.0)
		Default.RoomTypes.Item:
			spriteNode.modulate = Color(0.22, 0.51, 0.86, 1.0)
		Default.RoomTypes.Boss:
			spriteNode.modulate = Color(0.69, 0.21, 0.21, 1.0)
	$UndiscoveredSprite.queue_free()
