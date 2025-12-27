extends Control

signal rules_accepted

var rules_label: RichTextLabel = null
var accept_button: Button = null

# Rules data passed from main scene
var rules: Array = []

# Translation maps
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

func _ready() -> void:
	_setup_ui()
	_update_rules_display()

func _setup_ui():
	# Background panel
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel)

	# Create centered container
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center_container)

	# Vertical box for content
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 30)
	center_container.add_child(vbox)

	# Title
	var title_label = Label.new()
	title_label.text = "ПРАВИЛА ИГРЫ"
	title_label.add_theme_font_size_override("font_size", 48)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)

	# Rules text
	rules_label = RichTextLabel.new()
	rules_label.bbcode_enabled = true
	rules_label.add_theme_font_size_override("normal_font_size", 28)
	rules_label.custom_minimum_size = Vector2(600, 400)
	rules_label.fit_content = true
	rules_label.scroll_active = false
	vbox.add_child(rules_label)

	# Accept button
	accept_button = Button.new()
	accept_button.text = "Принять"
	accept_button.add_theme_font_size_override("font_size", 32)
	accept_button.custom_minimum_size = Vector2(300, 80)
	accept_button.pressed.connect(_on_accept_pressed)
	vbox.add_child(accept_button)

func set_rules(new_rules: Array):
	rules = new_rules
	if rules_label:
		_update_rules_display()

func _update_rules_display():
	if not rules_label:
		return

	var text = "[center]"

	if rules.size() == 0:
		text += "Добро пожаловать в игру!\n\n"
		text += "Смахивай лица влево или вправо\n"
		text += "в зависимости от их черт.\n\n"
	else:
		text += "Условия для смахивания [b]ВПРАВО[/b]:\n\n"
		for rule in rules:
			for feature in rule.keys():
				var feature_name = feature_translations.get(feature, feature)
				var value_name = value_translations.get(rule[feature], rule[feature])
				text += "[b]" + feature_name + "[/b] = " + value_name + "\n"
		text += "\n[color=green]Если условия совпадают → ВПРАВО[/color]\n"
		text += "[color=red]Иначе → ВЛЕВО[/color]\n"

	text += "[/center]"
	rules_label.text = text

func _on_accept_pressed():
	rules_accepted.emit()
