extends Node2D

func Open():
	$PlayerBarrier.set_collision_mask_bit(1, false)
	$AnimationPlayer.play("Open")

func Close():
	$PlayerBarrier.set_collision_mask_bit(1, true)
	$AnimationPlayer.play("Close")
