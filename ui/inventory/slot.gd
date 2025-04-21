extends Node2D

var item = null
var item_count = 0
var out = false
var sprite
var output = false

signal clear

func wipe():
	item = null
	item_count = 0
	$Sprite2D.visible = false
	$Label.text= "0"
	$Label.visible = false
	
func add_item(sprite,noun):
	if item == null:
		item = noun
		$Sprite2D.texture = sprite
		$Sprite2D.visible = true
		$Sprite2D.scale = Vector2(1.5,1.5)
		item_count = 1
		$Label.text = str(item_count)
		$Label.visible = true
		return true
	else:
		if item == noun:
			item = noun
			item_count += 1
			$Label.text = str(item_count)
			$Label.visible = true
			return true
	return false
			
func _process(delta:float):
	if out:
		sprite.position = get_local_mouse_position()

func _on_button_button_down() -> void:
	if InventoryManager.noun == null:
		if item!=null:
			print("something taken")
			out = true
			InventoryManager.noun = item
			InventoryManager.number = item_count
			InventoryManager.sprite = $Sprite2D.texture
			$Sprite2D.visible = false
			$Label.visible=false
			item = null
			item_count=0
			sprite = Sprite2D.new()
			add_child(sprite)
			sprite.texture = InventoryManager.sprite
			sprite.scale = Vector2(1.5,1.5)
			sprite.visible = true
			if output:
				emit_signal("clear")
				print('helloooo')
	else:
		if not out:
			print('something put inside')
			item = InventoryManager.noun
			$Sprite2D.texture = InventoryManager.sprite
			$Sprite2D.visible = true
			$Sprite2D.scale = Vector2(1.5,1.5)
			item_count = InventoryManager.number
			$Label.text = str(item_count)
			$Label.visible = true
			InventoryManager.noun = null
			for i in get_tree().get_nodes_in_group("slots"):
				if i.out:
					i.out = false
					i.sprite.queue_free()
		else:
			print("put into the same one")
			sprite.visible = false
			$Sprite2D.visible=true
			$Label.visible = true
			item = InventoryManager.noun
			item_count = InventoryManager.number
			InventoryManager.noun = null
			out = false

	
