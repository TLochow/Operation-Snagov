extends Node2D

func Play(effect):
	var effectName = str(Default.BreakingSoundEffects.keys()[effect])
	get_node(effectName).play()
