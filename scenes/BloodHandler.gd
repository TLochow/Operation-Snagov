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
	Global.ReparentNode(node, BloodToAdd)

func _process(delta):
	var bloodNodes = BloodToAdd.get_children()
	for blood in bloodNodes:
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
