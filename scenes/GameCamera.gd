extends Camera2D

onready var Player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	var pos = get_position()
	var relativePlayerPos = Player.get_position() - pos
	if relativePlayerPos.x < -256.0:
		pos.x -= 512.0
		set_position(pos)
	elif relativePlayerPos.x > 256.0:
		pos.x += 512.0
		set_position(pos)
	if relativePlayerPos.y < -112.0:
		pos.y -= 256.0
		set_position(pos)
	if relativePlayerPos.y > 144.0:
		pos.y += 256.0
		set_position(pos)
