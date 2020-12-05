extends "res://scenes/rooms/layouts/LayoutBase.gd"

func _on_InnerButton_Pressed():
	$OuterTurret.Armed = true

func _on_InnerButton_Released():
	$OuterTurret.Armed = false

func _on_OuterButton_Pressed():
	$InnerTurret.Armed = true

func _on_OuterButton_Released():
	$InnerTurret.Armed = false
