extends "res://scenes/items/ItemBase.gd"

func Collect(player):
	player.ShotAmount *= 2.0
