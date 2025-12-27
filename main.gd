extends Node

var face_node = null

var is_dragging := false
var swipe_start_pos := Vector2.ZERO
var swipe_threshold := 200.0
var is_animating := false

# Health counter (lives)
var health := 5
var health_label: Label = null
var rules_label: Label = null

# Rules dictionary: each rule defines a condition for swiping right
# Format: {"feature": "value"} - if face matches rule, swipe right; otherwise swipe left
var rules: Array = []

# Current face configuration (stored when spawning a new face)
var current_face_config: Dictionary = {}

# Translation map for feature names (for display)
var feature_translations = {
	"face_shape": "Голова",
	"eyes": "Глаза",
	"nose": "Нос",
	"mouth": "Рот",
	"eyebrows": "Брови",
	"cheeks": "Щёки"
}

var value_translations = {
	"circle": "круглая",
	"square": "квадратная",
	"oval": "овальная",
	"triangle": "треугольная",
	"trapezoid": "трапеция",
	"half_up": "полукруг вверх",
	"half_down": "полукруг вниз",
	"lines": "линии",
	"line": "линия",
	"v": "V-образный",
	"smile": "улыбка",
	"sad": "грустный",
	"neutral": "нейтральный",
	"wide": "широкий",
	"open": "открытый",
	"none": "нет",
	"straight": "прямые",
	"up": "вверх",
	"down": "вниз",
	"dots": "точки",
	"blush": "румянец"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_use_accumulated_input(false)  # для чёткости свайпов
	_setup_health_display()
	_setup_rules_display()
	_add_initial_rule()
	_spawn_new_face()

func _setup_health_display():
	health_label = Label.new()
	health_label.text = "❤️ " + str(health)
	health_label.add_theme_font_size_override("font_size", 32)
	health_label.add_theme_color_override("font_color", Color.RED)
	add_child(health_label)
	_update_health_label_position()

func _update_health_label_position():
	if health_label:
		var viewport_size = get_viewport().get_visible_rect().size
		health_label.position = Vector2(viewport_size.x - 120, 20)

func _update_health_display():
	if health_label:
		health_label.text = "❤️ " + str(health)

func _setup_rules_display():
	rules_label = Label.new()
	rules_label.add_theme_font_size_override("font_size", 20)
	rules_label.add_theme_color_override("font_color", Color.WHITE)
	rules_label.position = Vector2(20, 20)
	add_child(rules_label)

func _update_rules_display():
	if rules_label:
		var rule_text = "Правило: "
		for rule in rules:
			for feature in rule.keys():
				var feature_name = feature_translations.get(feature, feature)
				var value_name = value_translations.get(rule[feature], rule[feature])
				rule_text += feature_name + " = " + value_name + "\n"
		rules_label.text = rule_text + "→ Смахивай ВПРАВО\nИначе → ВЛЕВО"

func _add_initial_rule():
	# Add one rule at game start: e.g., square head
	rules.append({"face_shape": "square"})
	_update_rules_display()

func _check_face_matches_rules() -> bool:
	# Check if current face matches ALL rules
	for rule in rules:
		for feature in rule.keys():
			if current_face_config.has(feature):
				if current_face_config[feature] != rule[feature]:
					return false
			else:
				return false
	return true

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

	# Check if swipe direction is correct based on rules
	var face_matches = _check_face_matches_rules()
	var should_swipe_right = face_matches
	var swiped_right = (direction == "right")

	if should_swipe_right == swiped_right:
		# Correct swipe: +1 health
		health += 1
	else:
		# Incorrect swipe: -2 health
		health -= 2

	_update_health_display()

	# Check for game over
	if health <= 0:
		_game_over()
		return

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

	# Store face config after adding to scene (config is set in _ready)
	await get_tree().process_frame
	current_face_config = face_node.config.duplicate()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(face_node, "position", center, 0.4)
	tween.tween_property(face_node, "scale", Vector2(1, 1), 0.4)

func _game_over():
	is_animating = true
	# Show game over message
	var game_over_label = Label.new()
	game_over_label.text = "GAME OVER"
	game_over_label.add_theme_font_size_override("font_size", 64)
	game_over_label.add_theme_color_override("font_color", Color.RED)
	add_child(game_over_label)

	var viewport_size = get_viewport().get_visible_rect().size
	game_over_label.position = Vector2(viewport_size.x / 2 - 200, viewport_size.y / 2 - 50)

	# Fade out face
	if face_node:
		var tween = create_tween()
		tween.tween_property(face_node, "modulate:a", 0.0, 0.5)
		tween.tween_callback(face_node.queue_free)

