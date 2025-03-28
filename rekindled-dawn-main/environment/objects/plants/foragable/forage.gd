extends Sprite2D

var noun = 'carrot'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func affirm_type():
	return "forage"
	
func return_inv():
	visible = false
	return [texture,noun]
