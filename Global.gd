extends Node

var ROOMSCENE = preload("res://scenes/rooms/Room.tscn")
var LevelGenBlockedCoords = []

var CurrentLevel = 1

var TopEffectsNode
var DebrisNode

var BloodSprite
var BloodImage
var BloodImageSize
var BloodImageHalfSize

func PrepareBloodSprite(spriteNode, spriteSize):
	BloodImageSize = spriteSize
	BloodImageHalfSize = BloodImageSize * 0.5
	BloodSprite = spriteNode
	var imageTexture = ImageTexture.new()
	BloodImage = Image.new()
	BloodImage.create(BloodImageSize.x, BloodImageSize.y, false, Image.FORMAT_RGBA8)
	BloodImage.fill(Color(1.0, 1.0, 1.0, 0.0))
	BloodImage.lock()
	imageTexture.create_from_image(BloodImage)
	BloodSprite.texture = imageTexture

func RegisterBlood(pos):
	pos += BloodImageHalfSize
	BloodImage.set_pixel(pos.x,pos.y, Color(1.0, 0.0, 0.0, 1.0))
	BloodSprite.texture.set_data(BloodImage)
