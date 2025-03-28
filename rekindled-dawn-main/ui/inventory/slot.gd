extends Node2D

var slot_num: Vector2i
var item = null
var item_count = 0

func add_item(sprite,noun):
	if item == null:
		item = noun
		$Sprite2D.texture = sprite
		$Sprite2D.visible = true
		$Sprite2D.scale = Vector2(1.5,1.5)
		item_count = 1
		$Label.text = str(item_count)
		return true
	else:
		print(noun)
		if item == noun:
			item = noun
			item_count += 1
			$Label.text = str(item_count)
			return true
	return false
#testing code for inventory shit
#func _input(event: InputEvent):
	#if Input.is_action_just_pressed("interact"):
		#if item == null:
			#$Sprite2D.visible = true
			#$Sprite2D.texture=load("res://assets/tilesets/biome1/islandmiddle3.png")
			#$Sprite2D.scale = Vector2(2,2)
			#item = "Grass"
		#else:
			#item_count+=1
			#$Label.text = str(item_count)
			#print("uhh")
