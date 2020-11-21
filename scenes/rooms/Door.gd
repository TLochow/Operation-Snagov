extends Node2D

func Open():
	$AnimationPlayer.play("Open")

func Close():
	$AnimationPlayer.play("Close")
