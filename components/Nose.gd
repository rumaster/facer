
extends Node2D

var component_type = ""
var nose_offset_y = 10
var size = 8

func set_type(t):
	component_type = t

func _draw():
	var pos = Vector2(0, nose_offset_y)

	match component_type:
		"circle":
			draw_circle(pos, size, Color.DARK_GRAY)
		"triangle":
			var points = [
				pos + Vector2(0, -size * 1.5),
				pos + Vector2(size, size),
				pos + Vector2(-size, size)
			]
			draw_polygon(points, [Color.DARK_GRAY])
		"line":
			draw_line(pos + Vector2(0, -size), pos + Vector2(0, size), Color.DARK_GRAY, 3)
		"v":
			draw_line(pos + Vector2(-size, -size), pos, Color.DARK_GRAY, 3)
			draw_line(pos, pos + Vector2(size, -size), Color.DARK_GRAY, 3)
		_:
			# Default: draw simple nose
			draw_circle(pos, size, Color.DARK_GRAY)
