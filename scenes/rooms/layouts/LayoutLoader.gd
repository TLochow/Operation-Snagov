extends Node

var Level1Start = []
var Level1Default = []
var Level1Shop = []
var Level1Item = []
var Level1Boss = []

func LoadLayouts(level, type):
	var layouts = []
	var i = 1
	var loadingLayouts = true
	while loadingLayouts:
		var layout = load("res://scenes/rooms/layouts/level" + str(level) + "/" + type + str(i) + ".tscn")
		if layout == null:
			loadingLayouts = false
		else:
			layouts.append(layout)
			i += 1
	layouts.shuffle()
	return layouts

func LoadRandomLayoutByArray(layoutArrayName, type):
	var layout = null
	var layouts = get(layoutArrayName)
	if layouts.size() == 0:
		layouts = LoadLayouts(1, type)
		set(layoutArrayName, layouts)
	layout = layouts[0]
	layouts.remove(0)
	return layout

func LoadRandomLayout(level, type):
	var layout = null
	match level:
		1:
			match type:
				Default.RoomTypes.Start:
					layout = LoadRandomLayoutByArray("Level1Start", "Start")
				Default.RoomTypes.Normal:
					layout = LoadRandomLayoutByArray("Level1Default", "Default")
				Default.RoomTypes.Shop:
					layout = LoadRandomLayoutByArray("Level1Shop", "Shop")
				Default.RoomTypes.Item:
					layout = LoadRandomLayoutByArray("Level1Item", "Item")
				Default.RoomTypes.Boss:
					layout = LoadRandomLayoutByArray("Level1Boss", "Boss")
	return layout.instance()
