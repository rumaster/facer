
extends Node2D

var component_type = ""
var mouth_offset_y = 50
var size = 25

func set_type(t):
	component_type = t

func _draw():
	var pos = Vector2(0, mouth_offset_y)

	match component_type:
		"smile":
			draw_arc(pos, size, PI * 0.1, PI * 0.9, 24, Color.DARK_RED, 4)
		"sad":
			draw_arc(pos + Vector2(0, size), size, PI * 1.1, PI * 1.9, 24, Color.DARK_RED, 4)
		"neutral":
			draw_line(pos + Vector2(-size, 0), pos + Vector2(size, 0), Color.DARK_RED, 4)
		"wide":
			draw_arc(pos, size * 1.2, PI * 0.15, PI * 0.85, 24, Color.DARK_RED, 5)
		"open":
			draw_circle(pos, size * 0.5, Color.DARK_RED)
		_:
			# Default: draw neutral mouth
			draw_line(pos + Vector2(-size, 0), pos + Vector2(size, 0), Color.DARK_RED, 4)
