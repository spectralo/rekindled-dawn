extends CharacterBody2D

var boom = false
var walking = false

var xdir = 1 # == right -1 = left
var ydir = 1 # 1 == down -1 == up
var speed = 10

var motion = Vector2()

var moving_vertical_horizontal = 1 #1 = horizontal 2 = vertical

func _ready():
	walking = true
	randomize()
	
func _physics_process(delta):
	var waittime = 1
	if walking == false:
		var x = randf_range(1,2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2
	if walking == true:
		$AnimatedSprite2D.play("walking")
		if moving_vertical_horizontal == 1:
			if xdir == -1:
				$AnimatedSprite2D.flip_h = true
			if xdir == 1:
				$AnimatedSprite2D.flip_h = false
			motion.x = speed * xdir
			motion.y = 0
		elif moving_vertical_horizontal == 2:
			motion.y = speed * ydir
			motion.x = 0
	
	if boom == true:
		$AnimatedSprite2D.play("boom")
		motion.x = 0
		motion.y = 0
		
	velocity = motion
	move_and_slide()
	
func _on_changestatetimer_timeout():
	var waittime = 1
	if walking == true:
		boom = true
		walking = false
		waittime = randf_range(1,5)
	elif boom == true:
		walking = true
		boom = false
		waittime = randf_range(2,6)
	$changestatetimer.wait_time = waittime
	$changestatetimer.start()
	
func _on_walkingtimer_timeout() -> void:
	var x = randf_range(1,2)
	var y = randf_range(1,2)
	var waittime = randf_range(1,4)
	
	if x > 1.5:
		xdir = 1 #right
	else:
		xdir = -1 #left
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$walkingtimer.wait_time = waittime
	$walkingtimer.start()
		
