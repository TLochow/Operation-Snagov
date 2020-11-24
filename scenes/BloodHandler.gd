extends Node2D

onready var BloodToAdd = $BloodToAdd

var BloodSprite
var BloodImage
var BloodImageSize
var BloodImageHalfSize

func PrepareBloodSprite(spriteSize):
	BloodImageSize = spriteSize
	BloodImageHalfSize = BloodImageSize * 0.5
	BloodSprite = $BloodSprite
	var imageTexture = ImageTexture.new()
	BloodImage = Image.new()
	BloodImage.create(BloodImageSize.x, BloodImageSize.y, false, Image.FORMAT_RGBA8)
	BloodImage.fill(Color(1.0, 1.0, 1.0, 0.0))
	BloodImage.lock()
	imageTexture.create_from_image(BloodImage)
	BloodSprite.texture = imageTexture

func RegisterBlood(node):
	ReparentNode(node, BloodToAdd)

func ReparentNode(child, newParent):
	var oldParent = child.get_parent()
	oldParent.remove_child(child)
	newParent.add_child(child)

func _process(delta):
	if BloodToAdd.get_child_count() > 0:
		var blood = BloodToAdd.get_child(0)
		var pos = blood.get_position() + BloodImageHalfSize
		BloodImage.set_pixel(pos.x,pos.y, Color(1.0, 0.0, 0.0, 1.0))
		BloodSprite.texture.set_data(BloodImage)
		blood.queue_free()
