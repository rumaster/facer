extends Node2D

var component_type = ""
var size = 100
var color = Color.BEIGE

func set_type(t):
	component_type = t
#	update()

func _draw():
	match component_type:
		"circle":
			draw_circle(Vector2.ZERO, size, color)
		"square":
			draw_rect(Rect2(Vector2(-size, -size), Vector2(size*2, size*2)), Color.BEIGE)
		"oval":
			draw_oval(Vector2.ZERO, Vector2(50, 30), color)
		"triangle":
			var points = [
				Vector2(0, -40),
				Vector2(40, 40),
				Vector2(-40, 40)
			]
			draw_polygon(points, [color])
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
		"none":
			pass
		_:
			draw_line(Vector2(-10, -10), Vector2(10, 10), Color.BLACK)
			draw_line(Vector2(-10, 10), Vector2(10, -10), Color.BLACK)

func draw_oval(center: Vector2, size: Vector2, color: Color):
	var points = []
	for i in range(0, 360, 10):
		var angle = deg_to_rad(i)
		var x = size.x * cos(angle)
		var y = size.y * sin(angle)
		points.append(center + Vector2(x, y))
	draw_colored_polygon(points, color)
