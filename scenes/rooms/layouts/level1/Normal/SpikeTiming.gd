extends "res://scenes/rooms/layouts/LayoutBase.gd"

var CurrentGroup = 0
var Spikes = []

func _ready():
	var spikeGroups = $Spikes.get_children()
	var counter = 0
	for group in spikeGroups:
		Spikes.append([])
		var spikes = group.get_children()
		for spike in spikes:
			Spikes[counter].append(spike)
		counter += 1

func Activate():
	.Activate()
	$Timer.start()

func _on_Timer_timeout():
	SetSpikesForGroup(CurrentGroup, false)
	SetSpikesForGroup(wrapi(CurrentGroup - 2, 0, 8), true)
	CurrentGroup = wrapi(CurrentGroup + 1, 0, 8)

func SetSpikesForGroup(group, state):
	var spikes = Spikes[group]
	if state:
		for spike in spikes:
			spike.Extend()
	else:
		for spike in spikes:
			spike.Retract()

func _on_Button_Pressed():
	$Timer.stop()
	for i in range(8):
		SetSpikesForGroup(i, false)
	emit_signal("Cleared")
