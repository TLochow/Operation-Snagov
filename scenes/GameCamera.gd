extends Camera2D

signal ChangedRoom(dir)

onready var Player = get_tree().get_nodes_in_group("Player")[0]

func _input(event):
	if Global.IsDebug:
		if event.is_action_pressed("scroll_up"):
			zoom -= Vector2(0.2, 0.2)
		elif event.is_action_pressed("scroll_down"):
			zoom += Vector2(0.2, 0.2)
		elif event.is_action_pressed("mouse_middle"):
			set_position(.get_global_mouse_position())

func _process(delta):
	var pos = get_position()
	var relativePlayerPos = Player.get_position() - pos
	if relativePlayerPos.x < -256.0:
		pos.x -= 512.0
		set_position(pos)
		emit_signal("ChangedRoom", Default.DirLeft)
	elif relativePlayerPos.x > 256.0:
		pos.x += 512.0
		set_position(pos)
		emit_signal("ChangedRoom", Default.DirRight)
	if relativePlayerPos.y < -112.0:
		pos.y -= 256.0
		set_position(pos)
		emit_signal("ChangedRoom", Default.DirUp)
	if relativePlayerPos.y > 144.0:
		pos.y += 256.0
		set_position(pos)
		emit_signal("ChangedRoom", Default.DirDown)
