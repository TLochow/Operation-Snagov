extends StaticBody2D

var DEBRISSCENE = preload("res://scenes/objects/Debris.tscn")

export(float) var Health = 10.0

func Damage(damage, hitPoint, direction):
	Health -= damage
	if Health <= 0.0:
		Destroy(direction)

func Destroy(forceDirection):
	var pos = get_global_position()
	var spriteNode = $Sprite
	var spriteWidth = spriteNode.texture.get_width() / spriteNode.hframes
	var spriteHeight = spriteNode.texture.get_height() / spriteNode.vframes
	var spriteWidthTileAmount = max(floor(spriteWidth / 6.0), 1.0)
	var spriteHeightTileAmount = max(floor(spriteHeight / 6.0), 1.0)
	var spriteWidthTileSize = spriteWidth / spriteWidthTileAmount
	var spriteHeightTileSize = spriteHeight / spriteHeightTileAmount
	for x in range(spriteWidthTileAmount):
		for y in range(spriteHeightTileAmount):
			var debris = DEBRISSCENE.instance()
			debris.add_child(spriteNode.duplicate())
			debris.CutSprite(spriteWidthTileSize, spriteHeightTileSize, x, y)
			debris.rotation = rotation
			var spread = forceDirection.angle() + rand_range(-1.0, 1.0)
			debris.linear_velocity = (forceDirection + (Vector2(cos(spread), sin(spread)) * 50.0)) * rand_range(1.0, 10.0)
			var debrisPos = pos + Vector2(x * spriteWidthTileSize, y * spriteHeightTileSize) + Vector2(-spriteWidth * 0.5, -spriteHeight * 0.5)
			debrisPos = pos + (debrisPos - pos).rotated(rotation)
			debris.set_position(debrisPos)
			Global.DebrisNode.add_child(debris)
	queue_free()
