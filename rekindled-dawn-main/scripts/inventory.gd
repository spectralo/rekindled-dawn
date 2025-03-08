extends Node2D

var rows = 5
var cols = 4
var items = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(rows):
		items.append([])
		for j in range(cols):
			items[i].append([])		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
