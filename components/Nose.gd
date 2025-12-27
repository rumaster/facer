
extends Node2D

var component_type = ""

func set_type(t):
	component_type = t
#	update()

func _draw():
	# Простейший визуальный маркер для компонента
	draw_circle(Vector2.ZERO, 10, Color(1, 0, 0))
