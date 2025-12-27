extends Node2D

var component_type = ""
var size = 100
var color = Color.BEIGE

func set_type(t):
	component_type = t

func _draw():
	match component_type:
		"circle":
			draw_circle(Vector2.ZERO, size, color)
		"square":
			draw_rect(Rect2(Vector2(-size, -size), Vector2(size * 2, size * 2)), color)
		"oval":
			draw_oval(Vector2.ZERO, Vector2(size * 0.85, size * 1.1), color)
		"triangle":
			var points = [
				Vector2(0, -size),
				Vector2(size, size),
				Vector2(-size, size)
			]
			draw_polygon(points, [color])
		"trapezoid":
			var points = [
				Vector2(-size * 0.6, -size),
				Vector2(size * 0.6, -size),
				Vector2(size, size),
				Vector2(-size, size)
			]
			draw_polygon(points, [color])
		_:
			# Default: draw circle face
			draw_circle(Vector2.ZERO, size, color)

func draw_oval(center: Vector2, oval_size: Vector2, col: Color):
	var points = []
	for i in range(0, 360, 5):
		var angle = deg_to_rad(i)
		var x = oval_size.x * cos(angle)
		var y = oval_size.y * sin(angle)
		points.append(center + Vector2(x, y))
	draw_colored_polygon(points, col)
