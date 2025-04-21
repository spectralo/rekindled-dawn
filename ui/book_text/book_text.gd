extends CanvasLayer

@export var player: Node
# Called when the node enters the scene tree for the first time.
@onready var line_edit = $AnimatedSprite2D/LineEdit
@onready var rich_text_label = $AnimatedSprite2D/RichTextLabel

@onready var oline_edit = $AnimatedSprite2D/LineEdit2
@onready var orich_text_label = $AnimatedSprite2D/RichTextLabel2

signal finished


var texts = []
var index = 0
var text = null
var timer = 0
var done = false
var current = 0

func _ready():
	for i in range(10*2):
		texts.append("")
	line_edit.text_submitted.connect(_on_text_entered)
	oline_edit.text_submitted.connect(_on_text_entered2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer+=delta
	if timer>= 0.1:
		timer = 0
		if text != null:
			stream_text(text)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Book"):
		$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
		self.emit_signal("toggle")
	if Input.is_action_just_pressed("ui_right"):
		if index < 18 and $AnimatedSprite2D.visible:
			index += 2
			update_page()
	if Input.is_action_just_pressed("ui_left"):
		if index > 0 and $AnimatedSprite2D.visible:
			index -= 2
			update_page()

func _on_text_entered(new_text):
	rich_text_label.clear()
	rich_text_label.visible = true
	line_edit.visible = false
	rich_text_label.append_text("[color=white]" + new_text + "[/color]")  # Apply styling
	texts[index+1] = new_text
	line_edit.text = ""
	# Clear input
	
func _on_rich_text_label_input(event):
	if event is InputEventMouseButton and event.pressed:
		# Hide the RichTextLabel and show the LineEdit
		rich_text_label.visible = false
		line_edit.visible = true
		line_edit.grab_focus() 
		 # Auto-focus the LineEdit

func _on_text_entered2(new_text):
	orich_text_label.clear()
	orich_text_label.visible = true
	oline_edit.visible = false
	orich_text_label.append_text("[color=white]" + new_text + "[/color]")  # Apply styling
	texts[index] = new_text
	oline_edit.text = ""  # Clear input
	
func _on_rich_text_label_input2(event):
	if event is InputEventMouseButton and event.pressed:
		# Hide the RichTextLabel and show the LineEdit
		orich_text_label.visible = false
		oline_edit.visible = true
		oline_edit.grab_focus()  # Auto-focus the LineEdit


func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		rich_text_label.visible = false
		line_edit.visible = true


func _on_rich_text_label_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		orich_text_label.visible = false
		oline_edit.visible = true

func update_page():
	if texts[index] == "":
		rich_text_label.visible = false
		line_edit.visible = true
	else:
		rich_text_label.visible = true
		line_edit.visible = false
		rich_text_label.text = texts[index+1]
	if texts[index+1] == "":
		orich_text_label.visible = false
		oline_edit.visible = true
	else:
		orich_text_label.visible = true
		oline_edit.visible = false
		orich_text_label.text = texts[index]
		
func save():
	var a = []
	for i in range(texts.size()):
		a.append(texts[i])
	print(a)
	return a
	
func load(vals):
	for i in range(vals.size()):
		texts[i] = vals[i]
		
func stream_text(text):
	done = false
	if current < len(text):
		current += 1
	else:
		done = true
	$TextBox/MarginContainer/text.visible_characters=current
	

func _on_node_2d_text_moment(parent: Variant,pos: Variant) -> void:
	print('helloooo')
	if $TextBox.visible:
		if not done:
			return
		else:
			$TextBox.visible = not $TextBox.visible
			$TextBox.visible = $TextBox.visible
			done = true
			emit_signal("finished")
			return
	current = 0
	text = parent.get_text() #perform black magic and acquire text
	$TextBox /MarginContainer/text.visible_characters=0
	$TextBox/MarginContainer/text.text = text
	$TextBox.visible = not $TextBox.visible
	var ob_pos = parent.get_global_transform_with_canvas()
	$TextBox.position = ob_pos.get_origin()-((parent.get_node("CollisionShape2D").shape.extents*2*5)+Vector2(0,64))
	
