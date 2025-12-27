
extends Node2D

var component_type = ""
var size = 10
var color = Color.ORANGE_RED

var eye_offset_y = -30
var eye_spacing = 40

func set_type(t):
	component_type = t
#	update()

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
		"trapezoid":
			var points = [
				Vector2(-30, -40),
				Vector2(30, -40),
				Vector2(50, 40),
				Vector2(-50, 40)
			]
			draw_polygon(points, [Color.DARK_RED])
		"half_up":
			draw_arc(Vector2.ZERO, 40, PI, 2*PI, 32, Color.DARK_BLUE)
		"half_down":
			draw_arc(Vector2.ZERO, 40, 0, PI, 32, Color.DARK_BLUE)
		"lines":
			draw_line(Vector2(-30, 0), Vector2(30, 0), Color.BLACK, 4)
		"line":
			draw_line(Vector2(0, -30), Vector2(0, 30), Color.DARK_GRAY, 4)
		"v":
			draw_line(Vector2(-10, -20), Vector2(0, 0), Color.DARK_GRAY, 4)
			draw_line(Vector2(0, 0), Vector2(10, -20), Color.DARK_GRAY, 4)
		"smile":
			draw_arc(Vector2.ZERO, 30, PI*0.1, PI*0.9, 16, Color.MAGENTA, 4)
		"sad":
			draw_arc(Vector2.ZERO, 30, PI*1.1, PI*1.9, 16, Color.MAGENTA, 4)
		"neutral":
			draw_line(Vector2(-20, 0), Vector2(20, 0), Color.MAGENTA, 4)
		"wide":
			draw_arc(Vector2.ZERO, 40, 0.5, PI - 0.5, 24, Color.MAGENTA, 4)
		"open":
			draw_circle(Vector2.ZERO, 15, Color.RED)
		"straight":
			draw_line(Vector2(-20, -20), Vector2(20, -20), Color.BROWN, 3)
		"up":
			draw_line(Vector2(-20, -10), Vector2(20, -20), Color.BROWN, 3)
		"down":
			draw_line(Vector2(-20, -20), Vector2(20, -10), Color.BROWN, 3)
		"dots":
			draw_circle(Vector2(-20, 20), 6, Color.PINK)
			draw_circle(Vector2(20, 20), 6, Color.PINK)
		"blush":
			draw_circle(Vector2(-25, 20), 10, Color.PALE_VIOLET_RED)
			draw_circle(Vector2(25, 20), 10, Color.PALE_VIOLET_RED)
