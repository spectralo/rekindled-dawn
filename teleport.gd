extends AnimatedSprite2D

@export var other:Node
# Called when the node enters the scene tree for the first time.
func affirm_type():
	return "teleporter"

func send():
	return other.position
