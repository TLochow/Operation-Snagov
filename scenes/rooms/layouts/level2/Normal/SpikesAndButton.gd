extends "res://scenes/rooms/layouts/LayoutBase.gd"

func Activate():
	.Activate()
	ExtendSpikes()

func ExtendSpikes():
	var spikes = $Spikes.get_children()
	for spike in spikes:
		spike.Extend()

func RetractSpikes():
	var spikes = $Spikes.get_children()
	for spike in spikes:
		spike.Retract()

func _on_Button_Pressed():
	RetractSpikes()
	emit_signal("Cleared")
