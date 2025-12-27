extends Node2D

@export var radius: float = 50.0
@export var color: Color = Color(1, 1, 1)
@export var thickness: float = 2.0

func _ready():
	print("ready")
#	update()  # Перерисовать при запуске

func _draw():
	print("draw")

	draw_arc(
		Vector2.ZERO,
		radius,
		0,
		TAU,
		64,
		color,
		thickness
)
