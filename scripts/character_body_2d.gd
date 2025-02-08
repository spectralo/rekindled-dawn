extends CharacterBody2D

var direction = Vector2.ZERO
@onready var _animated_sprite = $AnimatedSprite2D
var moving = false
var collidee = null
var text =  null
var timer = 0
var current = 0
var done = true
func _physics_process(delta: float) -> void:
	timer+=delta
	if timer>= 0.05:
		timer = 0
		if text != null:
			stream_text(text)
	if Input.is_action_just_pressed("interact") and collidee.has_method("get_text"):
		if $textbox.visible:
			if not done:
				return
			else:
				$textbox.visible = not $textbox.visible
				$text.visible = $textbox.visible
				done = true
				return
		current = 0
		text = collidee.get_text()
		$text.visible_characters=0
		$text.text = text
		$textbox.visible = not $textbox.visible
		$text.visible = $textbox.visible
	if done:	
		if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left"):
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			if direction.x != 0 and direction.y != 0:
				direction.y = 0
				direction.x = 0
			move()

		if direction:
			if direction.x == 1:
				_animated_sprite.play("right")
			elif direction.x == -1:
				_animated_sprite.play("left")
			elif direction.y == -1:
				_animated_sprite.play("back")
			elif direction.y == 1:
				_animated_sprite.play("front")
		if not moving:
			_animated_sprite.stop()

func move():
	if moving or direction == Vector2.ZERO:
		return  
	var target_position = position + direction * 16 * 5
	var collision = move_and_collide(direction * 16 * 5,true)
	if collision:
		collidee = collision.get_collider()
		return 
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.35).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(move_false)

func move_false():
	moving = false
	
func stream_text(text):
	done = false
	if current < len(text):
		current += 1
	else:
		done = true
	$text.visible_characters=current
