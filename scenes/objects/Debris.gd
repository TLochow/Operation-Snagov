extends RigidBody2D

var SpriteNode

func CutSprite(width, height, xIndex, yIndex):
	move_child(SpriteNode, 0)
	var frameWidth = SpriteNode.texture.get_width() / SpriteNode.hframes
	var frameHeight = SpriteNode.texture.get_height() / SpriteNode.vframes
	var hFrameNumber = SpriteNode.frame % SpriteNode.hframes
	var vFrameNumber = floor(SpriteNode.frame / SpriteNode.hframes)
	SpriteNode.region_enabled = true
	SpriteNode.region_rect = Rect2(Vector2(width * xIndex, height * yIndex) + Vector2(frameWidth * hFrameNumber, frameHeight * vFrameNumber), Vector2(width, height))
	SpriteNode.set_hframes(1)
	SpriteNode.set_vframes(1)
	SpriteNode.frame = 0

func Explode(pos, strength):
	linear_velocity += (get_position() - pos).normalized() * strength * 30.0
