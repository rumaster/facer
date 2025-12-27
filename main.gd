extends Node

var face_node = null

var is_dragging := false
var swipe_start_pos := Vector2.ZERO
var swipe_threshold := 200.0
var is_animating := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_use_accumulated_input(false)  # для чёткости свайпов
	_spawn_new_face()

func _input(event):
	if is_animating:
		return

	# Начало касания / мыши
	if event is InputEventScreenTouch and event.pressed:
		swipe_start_pos = event.position
		is_dragging = true

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			swipe_start_pos = event.position
			is_dragging = true
		else:
			_end_swipe(event.position)

	# Движение пальца или мыши
	elif (event is InputEventScreenDrag or (event is InputEventMouseMotion and is_dragging)):
		_update_face_offset(event.position)

	# Отпускание пальца
	elif event is InputEventScreenTouch and not event.pressed:
		_end_swipe(event.position)

func _update_face_offset(current_pos: Vector2):
	var delta = current_pos - swipe_start_pos
	if not face_node:
		return

	# Смещение X ограничено
	var max_offset = 300.0
	var offset_x = clamp(delta.x, -max_offset, max_offset)

	# Наклон в градусах, максимум 20
	var max_tilt_deg = 20.0
	var tilt = offset_x / max_offset * deg_to_rad(max_tilt_deg)

	# visible_rect.size
	print(get_viewport().size)
	face_node.position = get_viewport().get_visible_rect().size / 2 + Vector2(offset_x, 0)
	face_node.rotation = tilt

func _end_swipe(end_pos: Vector2):
	is_dragging = false
	var delta = end_pos - swipe_start_pos
	if abs(delta.x) >= swipe_threshold:
		var direction = "right" if delta.x > 0 else "left"
		_animate_face_exit(direction)
	else:
		_animate_face_return()

func _animate_face_exit(direction: String):
	is_animating = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	var target_x = face_node.position.x + (500 if direction == "right" else -500)
	var target_rot = deg_to_rad(40) if direction == "right" else deg_to_rad(-40)

	tween.tween_property(face_node, "position:x", target_x, 0.3)
	tween.tween_property(face_node, "rotation", target_rot, 0.3)
	tween.tween_callback(Callable(self, "_on_face_exit_finished"))

func _animate_face_return():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(face_node, "position", get_viewport().get_visible_rect().size / 2, 0.3)
	tween.tween_property(face_node, "rotation", 0.0, 0.3)

func _on_face_exit_finished():
	face_node.queue_free()
	_spawn_new_face()
	is_animating = false

func _spawn_new_face():
	if face_node:
		face_node.queue_free()

	face_node = preload("res://FaceNode.tscn").instantiate()
	var center = get_viewport().get_visible_rect().size / 2
	face_node.position = center + Vector2(0, -300)
	face_node.scale = Vector2(0.5, 0.5)
	$FaceHolder.add_child(face_node)

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(face_node, "position", center, 0.4)
	tween.tween_property(face_node, "scale", Vector2(1, 1), 0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func randomize_face():
	return {
		"face_shape": ["circle", "square"].pick_random(),
		"eye_shape": ["circle", "square", "triangle"].pick_random(),
		"nose_shape": ["circle", "triangle"].pick_random(),
		"mouth_shape": ["smile", "frown"].pick_random(),
	}
