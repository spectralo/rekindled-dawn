extends CharacterBody2D

var direction = Vector2.ZERO
var moving = false

#these three are here for text streaming :3
var text =  null
var timer = 0
var current = 0
#for movement
var done = true
var dir = "front"
var cooldown = false
var thing = null
var col
var HP = 50
@onready var _animated_sprite = $AnimatedSprite2D
@onready var cdtime: Timer = $cooldowntime
#random helper functions

#here so that you can use the same variable named dir for both animation of sprites as well as math
func translate_dir(dir):
	if dir == "left":
		return Vector2(-1,0)
	if dir == "right":
		return Vector2(1,0)
	if dir == "back":
		return Vector2(0,-1)
	if dir == "front":
		return Vector2(0,1)
		
func affirm_type():
	return "player"
		
@warning_ignore("shadowed_variable")
#allows things to move in a grid, mode 0 is walk, mode 1 is dash, mode 2 is mouse dash
func move(mode=0):
	if HP:
		var trans = Tween.TRANS_LINEAR
		if mode == 1:
			direction*=3
			trans = Tween.TRANS_SPRING
		if mode == 2:
			direction = (get_global_mouse_position()-position).normalized()*5
			direction.x = int(direction.x)
			direction.y = int(direction.y)
			trans = Tween.TRANS_SPRING
		if direction.x != 0 and direction.y != 0:
			direction.normalized()
		if moving or direction == Vector2.ZERO:
			return  
			
		var target_position = position + direction * 16 * 5
		var collision = move_and_collide(direction * 16 * 5,true)
		
		if collision:
			var collidee = collision.get_collider()
			if collidee.has_method("affirm_type"):
				if mode == 2:
					collidee.HP -= 1
					collidee.direction = Vector2(-int(collision.get_normal().x),-int(collision.get_normal().y))*-5
					collidee.move(0)
			else:
				return 
				
		moving = true #moving determines if your next keypress immediately starts moving the character or after one full grid based movement
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 0.2).set_trans(trans)
		tween.tween_callback(move_false)
	else:
		pass
func move_false():
	moving = false

#just increments visible character, helper function for talk()
@warning_ignore("shadowed_variable")
func stream_text(text):
	done = false
	if current < len(text):
		current += 1
	else:
		done = true
	$text.visible_characters=current

func animate():
	if direction:
		if direction.x > 0:
			_animated_sprite.play("right")
			dir = "right"
		elif direction.x < 0:
			_animated_sprite.play("left")
			dir = "left"
		elif direction.y < 0:
			_animated_sprite.play("back")
			dir = "back"
		elif direction.y > 0:
			_animated_sprite.play("front")
			dir = "front"

#this function has a fun thingy, this gets it's text from the NPC object's get_text function,
#if there is no get_text function, the collider object will be set to null, because who really cares :D
func talk(delta):
	if thing == null:
		return
	timer+=delta
	if timer>= 0.05:
		timer = 0
		if text != null:
			stream_text(text)
	#This is toggling the visibility of the text box
	if Input.is_action_just_pressed("interact") and thing.has_method("get_text"):
		if $textbox.visible:
			if not done:
				return
			else:
				$textbox.visible = not $textbox.visible
				$text.visible = $textbox.visible
				done = true
				return
		current = 0
		text = thing.get_text() #perform black magic and acquire text
		$text.visible_characters=0
		$text.text = text
		$textbox.visible = not $textbox.visible
		$text.visible = $textbox.visible

#here to  hurt things if they are real (are NPCs), and also the keyboard based dashing
func process_input():
	if done:	
		if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left"):
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")		
			if Input.is_action_pressed("interact") and cdtime.is_stopped():
				move(1)
				cdtime.start()
				return		
			move(0)
			
#ACTUAL GAME STUFF WOOO
func _physics_process(delta: float) -> void:
	talk(delta)
	process_input()
	animate()
	#checks if there is an object adjacent in the direction the character is pointing towards
	col = move_and_collide(translate_dir(dir)*16*5,true)
	if col:
		thing = col.get_collider()	
	else: 
		thing = null
	if not moving:
		_animated_sprite.stop()
			
func _input(event: InputEvent) -> void:
	#mouse dash >:) 
	if event is InputEventMouseButton:
		if event.double_click and event.button_index == 1:
			move(2)
	#mouse attack, again, after checking if the thing being hurt is real
	if Input.is_action_just_pressed("hurt"):
		if thing != null:
			if thing.has_method("affirm_type"):
				thing.HP -= 1
				print(thing.tween_exists)
				if thing.tween_exists:
					print("DIE HEATHEN DIE REE")
					thing.tween.kill()
				thing.direction = translate_dir(dir)
				thing.move(0)
				_animated_sprite.play("attack_"+dir)
