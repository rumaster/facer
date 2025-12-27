extends Node2D

func _ready():
	var config = {
		"face_shape": ["circle", "square", "oval", "triangle", "trapezoid"].pick_random(),
		"eyes": ["circle", "square", "triangle", "half_up", "half_down", "lines"].pick_random(),
		"nose": ["circle", "triangle", "line", "v"].pick_random(),
		"mouth": ["smile", "sad", "neutral", "wide", "open"].pick_random(),
		"eyebrows": ["none", "straight", "up", "down"].pick_random(),
		"cheeks": ["none", "dots", "blush", "lines"].pick_random()
	}

	var shape = preload("res://components/FaceShape.gd").new()
	shape.set_type(config.face_shape)
	add_child(shape)

	var eyes = preload("res://components/Eyes.gd").new()
	eyes.set_type(config.eyes)
	add_child(eyes)

	var nose = preload("res://components/Nose.gd").new()
	nose.set_type(config.nose)
	add_child(nose)

	var mouth = preload("res://components/Mouth.gd").new()
	mouth.set_type(config.mouth)
	add_child(mouth)

	var brows = preload("res://components/Eyebrows.gd").new()
	brows.set_type(config.eyebrows)
	add_child(brows)

	var cheeks = preload("res://components/Cheeks.gd").new()
	cheeks.set_type(config.cheeks)
	add_child(cheeks)
