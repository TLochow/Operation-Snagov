extends Node2D

signal Cleared

var RoomOpenTop = false
var RoomOpenBottom = false
var RoomOpenLeft = false
var RoomOpenRight = false

export(bool) var IsEnemyBased = false

onready var EnemyNode = $Enemies

func _ready():
	set_process(false)

func Activate():
	set_process(true)

func _process(delta):
	if IsEnemyBased:
		if EnemyNode.get_child_count() == 0:
			set_process(false)
			emit_signal("Cleared")
