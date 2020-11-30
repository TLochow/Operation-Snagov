extends Node

var DEBRISSCENE = preload("res://scenes/objects/Debris.tscn")

func SpawnDebris(spriteNode, baseRotation, forceDirection, basePos):
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
			debris.rotation = baseRotation + spriteNode.rotation
			var spread = forceDirection.angle() + rand_range(-1.0, 1.0)
			debris.linear_velocity = (forceDirection + (Vector2(cos(spread), sin(spread)) * 50.0)) * rand_range(1.0, 10.0)
			var debrisPos = basePos + Vector2(x * spriteWidthTileSize, y * spriteHeightTileSize) + Vector2(-spriteWidth * 0.5, -spriteHeight * 0.5)
			debrisPos = basePos + (debrisPos - basePos).rotated(debris.rotation)
			debris.set_position(debrisPos)
			Global.DebrisNode.call_deferred("add_child", debris)
