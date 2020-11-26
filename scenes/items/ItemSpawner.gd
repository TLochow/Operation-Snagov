extends Node2D

var Item

func _ready():
	Item = ItemLoader.LoadRandomItem()

func Activate():
	call_deferred("add_child", Item)
