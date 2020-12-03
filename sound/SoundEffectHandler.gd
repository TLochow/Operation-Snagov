extends Node2D

func Play(effect):
	var effectName = str(Default.SoundEffects.keys()[effect])
	get_node(effectName).play()
