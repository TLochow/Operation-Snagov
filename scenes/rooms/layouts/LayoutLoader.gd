extends Node

var Layouts = {}

func LoadLayouts(layoutArrayName):
	var layouts = []
	var basePath = "res://scenes/rooms/layouts/level" + layoutArrayName
	var layoutPaths = Global.GetAllFilesFromDirectory(basePath)
	for path in layoutPaths:
		if path.ends_with(".tscn"):
			layouts.append(load(basePath + "/" + path))
	layouts.shuffle()
	return layouts

func LoadRandomLayoutByArray(layoutArrayName):
	var layout = null
	var layouts = []
	if Layouts.has(layoutArrayName):
		layouts = Layouts[layoutArrayName]
	if layouts.size() == 0:
		layouts = LoadLayouts(layoutArrayName)
		Layouts[layoutArrayName] = layouts
	layout = layouts[0]
	layouts.remove(0)
	return layout

func LoadRandomLayout(level, type):
	var typeName = str(Default.RoomTypes.keys()[type])
	return LoadRandomLayoutByArray(str(level) + "/" + typeName).instance()
