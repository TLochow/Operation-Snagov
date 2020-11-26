extends Node

var ITEMSCENE = preload("res://scenes/items/Item.tscn")

var Items = []

func LoadItems():
	for i in Default.Items.values():
		Items.append(i)
	Items.shuffle()

func LoadRandomItem():
	if Items.size() == 0:
		LoadItems()
	var itemType = Items[0]
	Items.remove(0)
	var item = ITEMSCENE.instance()
	item.ItemType = itemType
	return item
