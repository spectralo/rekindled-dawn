extends CharacterBody2D

var counter = 0
var lines = ["Quack","I wanna yap about stuff I'm not supposed to yap about", "Feeeeesh :3"]

func get_text():
	if counter < lines.size():
		counter+=1
	return lines[counter-1]
