extends RigidBody2D

func CutSprite(width, height, xIndex, yIndex):
	var spriteNode = get_node("Sprite")
	move_child(spriteNode, 0)
	var frameWidth = spriteNode.texture.get_width() / spriteNode.hframes
	var frameHeight = spriteNode.texture.get_height() / spriteNode.vframes
	var hFrameNumber = spriteNode.frame % spriteNode.hframes
	var vFrameNumber = floor(spriteNode.frame / spriteNode.hframes)
	spriteNode.region_enabled = true
	spriteNode.region_rect = Rect2(Vector2(width * xIndex, height * yIndex) + Vector2(frameWidth * hFrameNumber, frameHeight * vFrameNumber), Vector2(width, height))
	spriteNode.set_hframes(1)
	spriteNode.set_vframes(1)
	spriteNode.frame = 0

func Explode(pos, strength):
	linear_velocity += (get_position() - pos).normalized() * strength * 300.0
