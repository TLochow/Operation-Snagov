extends Node2D

onready var BloodToAdd = $BloodToAdd
onready var BloodSpritesNode = $BloodSprites

var BloodImageSize = Vector2(512.0, 512.0)

var BloodImages = {}
var BloodSprites = {}

func PrepareBloodSprite(pos):
	var bloodSprite = Sprite.new()
	var imageTexture = ImageTexture.new()
	var bloodImage = Image.new()
	bloodImage.create(BloodImageSize.x, BloodImageSize.y, false, Image.FORMAT_RGBA8)
	bloodImage.fill(Color(1.0, 1.0, 1.0, 0.0))
	bloodImage.lock()
	imageTexture.create_from_image(bloodImage)
	bloodSprite.texture = imageTexture
	bloodSprite.set_position((pos * BloodImageSize) + (BloodImageSize * 0.5))
	BloodImages[pos] = bloodImage
	BloodSprites[pos] = bloodSprite
	BloodSpritesNode.add_child(bloodSprite)

func RegisterBlood(node):
	ReparentNode(node, BloodToAdd)

func ReparentNode(child, newParent):
	var oldParent = child.get_parent()
	oldParent.remove_child(child)
	newParent.add_child(child)

func _process(delta):
	if BloodToAdd.get_child_count() > 0:
		var blood = BloodToAdd.get_child(0)
		var pos = blood.get_position()
		var keyPos = Vector2(floor(pos.x / BloodImageSize.x), floor(pos.y / BloodImageSize.y))
		if not BloodImages.has(keyPos):
			PrepareBloodSprite(keyPos)
		var bloodImage = BloodImages[keyPos]
		var x = fmod(pos.x, BloodImageSize.x)
		var y = fmod(pos.y, BloodImageSize.y)
		if x < 0.0:
			x = BloodImageSize.x + x
		if y < 0.0:
			y = BloodImageSize.y + y
		pos = Vector2(x, y)
		bloodImage.set_pixel(pos.x,pos.y, Color(1.0, 0.0, 0.0, 1.0))
		BloodSprites[keyPos].texture.set_data(bloodImage)
		blood.queue_free()
