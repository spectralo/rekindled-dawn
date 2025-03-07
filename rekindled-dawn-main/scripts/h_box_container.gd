extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in get_child_count():
		print(i,get_parent().HP)
		if get_parent().HP > i*2+1:
			get_child(i).play("full")
		elif get_parent().HP > i*2:
			get_child(i).play("half")
		else:
			get_child(i).play("empty")
