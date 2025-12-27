
extends Node2D

var component_type = ""
var cheek_offset_y = 20
var cheek_spacing = 60
var cheek_size = 10

func set_type(t):
	component_type = t

func _draw():
	var left_pos = Vector2(-cheek_spacing, cheek_offset_y)
	var right_pos = Vector2(cheek_spacing, cheek_offset_y)

	match component_type:
		"none":
			pass
		"dots":
			draw_circle(left_pos, cheek_size * 0.6, Color.PINK)
			draw_circle(right_pos, cheek_size * 0.6, Color.PINK)
		"blush":
			draw_circle(left_pos, cheek_size, Color.PALE_VIOLET_RED)
			draw_circle(right_pos, cheek_size, Color.PALE_VIOLET_RED)
		"lines":
			# Draw small horizontal lines on cheeks
			for i in range(3):
				var offset = Vector2(0, (i - 1) * 5)
				draw_line(left_pos + offset + Vector2(-8, 0), left_pos + offset + Vector2(8, 0), Color.PINK, 2)
				draw_line(right_pos + offset + Vector2(-8, 0), right_pos + offset + Vector2(8, 0), Color.PINK, 2)
		_:
			pass
