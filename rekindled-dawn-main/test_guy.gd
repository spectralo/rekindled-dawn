extends Node2D


const lines: Array[String] = [
	"Feeeeeeesh",
	"Second time texboxing",
	"redbull doesnt work sob",
	"fml",
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if interaction_area.get_overlapping_bodies().size() > 0:
			InteractionLabel.hide_label()
			DialogManager.start_dialog(global_position, lines)
			sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.y

func _on_interaction_area_body_entered(body):
	InteractionLabel.show_label(global_position, "talk")
	
func _on_interaction_area_body_exited(body):
	
