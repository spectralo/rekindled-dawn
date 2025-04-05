extends HBoxContainer

func add_item(sprite,noun):
	for i in get_children():
		if i.add_item(sprite,noun):
			return
