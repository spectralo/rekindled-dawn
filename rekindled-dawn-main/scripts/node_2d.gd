extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not FileAccess.file_exists("res://savegame.save"):
		return
	else: 
		var save_file = FileAccess.open("res://savegame.save", FileAccess.READ)
		print("File Size:", save_file.get_length())
		var save_nodes = get_tree().get_nodes_in_group("Persists")
		for node in save_nodes:
			if not node.has_method("load"):
				print("Persistent node '%s' is missing a load() function, skipped" % node.name)
				continue
			var node_data = save_file.get_var(true)
			node.call("load", node_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("Save"):
		var save_file = FileAccess.open("res://savegame.save", FileAccess.WRITE)
		var save_nodes = get_tree().get_nodes_in_group("Persists")
		for node in save_nodes:
			if !node.has_method("save"):
				continue

			var node_data = node.call("save")
			save_file.store_var(node_data,true)
