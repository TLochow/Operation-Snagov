extends Node2D

var Fires = []

func RegisterFire(fire):
	Fires.append(weakref(fire))
	if Fires.size() > 120:
		var first = Fires[0].get_ref()
		if first:
			first.call_deferred("queue_free")
		Fires.remove(0)
