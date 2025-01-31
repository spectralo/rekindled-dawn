extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		if not is_on_wall_only():
			if direction.x == 1:
				_animated_sprite.play("right")
			elif direction.x==-1:
				_animated_sprite.play("left")
			elif direction.y == -1:
				_animated_sprite.play("back")
			elif direction.y == 1:
				_animated_sprite.play("front")
		else:
			_animated_sprite.stop()
	else:
		_animated_sprite.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
