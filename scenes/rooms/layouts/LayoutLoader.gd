extends Node

var Layouts = {}

func LoadLayouts(layoutArrayName):
	var layouts = []
	var basePath = "res://scenes/rooms/layouts/level" + layoutArrayName
	var layoutPaths = GetAllFilesFromDirectory(basePath)
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

func GetAllFilesFromDirectory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not dir.current_is_dir():
			files.append(file)
	dir.list_dir_end()
	return files
