extends CanvasLayer
var noun = null
var sprite = null
var number = null
# Called when the node enters the scene tree for the first time.
var recipes = [["carrot"]]
var textures = [preload("res://environment/tilemaps/carrotground.png")]

var cooked = false


func _ready():
	$slot5.output =  true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ings = []
	for i in get_children():
		if i.has_method("add_item") and i.name!="slot5":
			if i.item != null:
				ings.append(i.item)
	ings.sort()
	if not cooked:
		for i in range(recipes.size()):
			if recipes[i] == ings:
				$slot5.add_item(textures[i],str(i))
				cooked = true

func _on_slot_5_clear() -> void:
	for i in get_children():
		if i.has_method("add_item") and i.name!="slot5":
			print('wiped')
			i.wipe()
	cooked = false
