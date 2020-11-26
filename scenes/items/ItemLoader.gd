extends Node

var Items = []

func LoadItems():
	Items = []
	var basePath = "res://scenes/items/items/"
	var itemPaths = GetAllFilesFromDirectory(basePath)
	for path in itemPaths:
		if path.ends_with(".tscn"):
			Items.append(load(basePath + "/" + path))
	Items.shuffle()

func LoadRandomItem():
	if Items.size() == 0:
		LoadItems()
	var item = Items[0]
	Items.remove(0)
	return item.instance()

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
