
extends Node2D

var component_type = ""
var brow_offset_y = -50
var brow_spacing = 40
var brow_width = 20

func set_type(t):
	component_type = t

func _draw():
	var left_pos = Vector2(-brow_spacing, brow_offset_y)
	var right_pos = Vector2(brow_spacing, brow_offset_y)

	draw_eyebrow(left_pos, false)
	draw_eyebrow(right_pos, true)

func draw_eyebrow(pos: Vector2, is_right: bool):
	var direction = 1 if is_right else -1

	match component_type:
		"none":
			pass
		"straight":
			draw_line(pos + Vector2(-brow_width, 0), pos + Vector2(brow_width, 0), Color.SADDLE_BROWN, 3)
		"up":
			# Inner part higher than outer part (angry look)
			draw_line(pos + Vector2(-brow_width * direction, 5), pos + Vector2(brow_width * direction, -5), Color.SADDLE_BROWN, 3)
		"down":
			# Outer part higher than inner part (worried look)
			draw_line(pos + Vector2(-brow_width * direction, -5), pos + Vector2(brow_width * direction, 5), Color.SADDLE_BROWN, 3)
		_:
			pass
