extends CharacterBody2D

var HP = 100
#ADD THIS FUNCTION TO ALL NPCS WITH TEXT 
func get_text():
	return "You should join #raghavs-ridiculous-ramblings on slack :3 this is a test to see where the text goes"
#this exists for no other reason than telling the player code that it is an NPC with HP, probably will be replaced by a has HP function
func affirm_type():
	return "NPC"

func _process(delta):
	if HP <= 0:
		self.visible = false

		
