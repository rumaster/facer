
extends Node2D

var component_type = ""
var size = 10
var color = Color.BLACK

var eye_offset_y = -30
var eye_spacing = 40

func set_type(t):
	component_type = t

func _draw():
	var eye_pos_left = Vector2(-eye_spacing, eye_offset_y)
	var eye_pos_right = Vector2(eye_spacing, eye_offset_y)

	draw_eye(eye_pos_left)
	draw_eye(eye_pos_right)

func draw_eye(pos: Vector2):
	match component_type:
		"circle":
			draw_circle(pos, size, Color.BLACK)
		"square":
			draw_rect(Rect2(pos - Vector2(size, size), Vector2(size*2, size*2)), Color.BLACK)
		"triangle":
			var points = [
				pos + Vector2(0, -size),
				pos + Vector2(size, size),
				pos + Vector2(-size, size)
			]
			draw_polygon(points, [Color.BLACK])
		"half_up":
			draw_arc(pos, size, PI, 2*PI, 32, Color.BLACK, 3)
		"half_down":
			draw_arc(pos, size, 0, PI, 32, Color.BLACK, 3)
		"lines":
			draw_line(pos + Vector2(-size, 0), pos + Vector2(size, 0), Color.BLACK, 3)
		_:
			# Default: draw simple circle eyes
			draw_circle(pos, size, Color.BLACK)
