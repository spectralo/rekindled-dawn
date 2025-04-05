extends CharacterBody2D

@export var targ: Node
@export var type: int

var direction = Vector2.ZERO
var moving = false
var HP = 10
var tween: Tween
var tpos: Vector2
var tween_exists = false
var hit = false
var kill = false

@onready var target = targ.get_node("player")
@onready var otherpos = target.position
@onready var cooldown = $attacktimer

func _ready():
	if type == 1:
		cooldown.wait_time = 2
		
func _process(delta):
	if HP and kill:
		otherpos = target.global_position
		if tween_exists:
			if not tween.is_running():
				tween_exists = false
			var collision = move_and_collide(position-otherpos,true)
			if collision and not hit:
				if collision.get_collider().has_method("affirm_type"):
					if collision.get_collider().affirm_type() == "player":
						print('hellllllllllllllllll')
						collision.get_collider().direction = Vector2(-collision.get_normal().x*2,-collision.get_normal().y*2)
						collision.get_collider().move(0)
						collision.get_collider().HP-=1
				else:
					position += collision.get_normal()*16*5
				tween.kill()
		if type == 0:
			velocity = (otherpos-position).normalized()*5
			print(otherpos)
			var collision = move_and_collide(velocity)
			if collision:
				attack(collision.get_collider(),collision)
		if type == 1:
			if cooldown.is_stopped():
				var target_position = position+(position-otherpos).normalized()*-80*4
				tween_exists = true
				tween = create_tween()
				tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_SPRING)
				tpos = target_position
				cooldown.start()
		if type == 2:
			otherpos.get_distance()
	if HP <= 0:
		queue_free()
	#
func attack(collidee,collision):
	if cooldown.is_stopped():
		if collidee.has_method("affirm_type"):
			collidee.HP -= 1
			collidee.direction = Vector2(-int(collision.get_normal().x*2),-int(collision.get_normal().y)*2)
			collidee.move(0)
			cooldown.start()
			
func affirm_type():
	return "enemy"
	
func move(mode=0,transtime=0.2):
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
			pass 
		var target_position = position + direction * 16 * 5
		var collision = move_and_collide(direction * 16 * 5,true)
		
		if collision:
			var collidee = collision.get_collider()
			if collidee.has_method("affirm_type"):
				if mode == 2:
					print('hellooooo')
					collidee.HP -= 1
					collidee.direction = Vector2(-int(collision.get_normal().x),-int(collision.get_normal().y))*160
					collidee.move(0)
			else:
				pass 
				
		moving = true #moving determines if your next keypress immediately starts moving the character or after one full grid based movement
		
		tween = create_tween()
		tween_exists = true
		tween.tween_property(self, "position", target_position, transtime).set_trans(trans)
		tween.tween_callback(move_false)

	else:
		pass
		
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"current_health" : HP,
	}
	return [position.x,position.y,HP]
	
func load(vals):
	position.x = vals[0]
	position.y = vals[1]
	HP = vals[2]
	
func move_false():
	moving = false
	hit = false

func _on_alert_area_entered(area: Area2D) -> void:
	if area.get_parent().affirm_type()=="player":
		kill = true
		print('entered')
	else:
		if area.get_parent().affirm_type()=='enemy' and area.get_parent().kill:
			kill = true
