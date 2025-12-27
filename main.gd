extends Node

# Main scene that manages transitions between rules and gameplay scenes

var rules_scene = null
var gameplay_scene = null

# Rules data shared between scenes
var rules: Array = []

# Swipe counter for adding new rules
var total_swipes := 0
var swipes_for_next_rule := 10

# Track if this is first time showing rules
var is_first_rules := true

# All possible rules configurations
var all_features = ["face_shape", "eyes", "nose", "mouth", "eyebrows", "cheeks"]

var feature_values = {
	"face_shape": ["circle", "square", "oval", "triangle", "trapezoid"],
	"eyes": ["circle", "square", "triangle", "half_up", "half_down", "lines"],
	"nose": ["circle", "triangle", "line", "v"],
	"mouth": ["smile", "sad", "neutral", "wide", "open"],
	"eyebrows": ["none", "straight", "up", "down"],
	"cheeks": ["none", "dots", "blush", "lines"]
}

func _ready() -> void:
	# Add initial rule
	_add_new_rule()
	# Show rules at game start
	_show_rules()

func _add_new_rule():
	# Add a random rule that is not already in the list
	var available_features = []
	for feature in all_features:
		var feature_used = false
		for rule in rules:
			if rule.has(feature):
				feature_used = true
				break
		if not feature_used:
			available_features.append(feature)

	if available_features.size() > 0:
		var random_feature = available_features.pick_random()
		var random_value = feature_values[random_feature].pick_random()
		rules.append({random_feature: random_value})

func _show_rules():
	# Hide gameplay if visible
	if gameplay_scene:
		gameplay_scene.queue_free()
		gameplay_scene = null

	# Create rules scene
	rules_scene = preload("res://rules.tscn").instantiate()
	rules_scene.set_rules(rules)
	rules_scene.rules_accepted.connect(_on_rules_accepted)
	add_child(rules_scene)

func _on_rules_accepted():
	# Hide rules scene
	if rules_scene:
		rules_scene.queue_free()
		rules_scene = null

	# Show gameplay scene
	_show_gameplay()

func _show_gameplay():
	gameplay_scene = preload("res://gameplay.tscn").instantiate()
	gameplay_scene.set_rules(rules)
	gameplay_scene.swipe_completed.connect(_on_swipe_completed)
	gameplay_scene.game_over_triggered.connect(_on_game_over)
	add_child(gameplay_scene)

func _on_swipe_completed():
	total_swipes += 1
	if total_swipes >= swipes_for_next_rule:
		total_swipes = 0
		_add_new_rule()
		_show_rules()

func _on_game_over():
	# Reset game state
	rules.clear()
	total_swipes = 0
	is_first_rules = true

	# After a delay, restart
	await get_tree().create_timer(3.0).timeout

	# Add initial rule and show rules
	_add_new_rule()
	_show_rules()
