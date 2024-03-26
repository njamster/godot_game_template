extends ColorRect


const AUTOMATIC_SCROLL_SPEED = 2 # pixels per frame
const MANUAL_SCROLL_SPEED = 8 # pixels per input event

@onready var SCROLL_CONTAINER := $OuterMargin/Scrollable
@onready var CREDITS := $OuterMargin/Scrollable/Credits

var frames_till_autoscroll := 0


func _ready() -> void:
	var spacer1 = Control.new()
	var spacer2 = Control.new()

	await get_tree().process_frame # to be able to change the minimum size
	spacer1.custom_minimum_size.y = SCROLL_CONTAINER.size.y
	spacer2.custom_minimum_size.y = 40

	CREDITS.add_child(spacer1)
	_load_project_credits()
	_load_godot_credits()
	CREDITS.add_child(spacer2)


func _add_category() -> VBoxContainer:
	var current_category = VBoxContainer.new()
	CREDITS.add_child(current_category)
	return current_category


func _add_headline(text: String) -> VBoxContainer:
	var label = Label.new()
	var current_category = _add_category()
	current_category.add_child(label)

	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme_type_variation = "Headline"
	label.text = text.lstrip("# ")

	return current_category


func _add_text(text: String, category: VBoxContainer, is_license := false) -> void:
	var label = Label.new()
	if category:
		category.add_child(label)
	else:
		CREDITS.add_child(label)

	if is_license:
		label.add_theme_color_override("font_color", "999")
		label.add_theme_font_size_override("font_size", 24)

	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = text



func _add_image(path: String, category: VBoxContainer) -> void:
	var image := TextureRect.new()
	if category:
		category.add_child(image)
	else:
		CREDITS.add_child(image)

	image.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	image.texture = load(path)


func _load_project_credits() -> void:
	var file = FileAccess.open("res://menu_screens/credits/credits.md", FileAccess.READ)

	var current_category
	while file.get_position() < file.get_length():
		var line = file.get_line()
		if line:
			if line.begins_with("# "):
				current_category = _add_headline(line.lstrip("# "))
			else:
				_add_text(line, current_category)


func _load_godot_credits() -> void:
	# see: https://docs.godotengine.org/en/stable/about/complying_with_licenses.html

	var category1 = _add_headline("Made with")
	_add_image("res://menu_screens/credits/images/godot_logo.svg", category1)
	_add_text(Engine.get_license_text(), category1, true)

	var copyright_info := Engine.get_copyright_info()
	var license_infos := Engine.get_license_info()

	for library_name in ["The FreeType Project", "ENet", "Mbed TLS"]:
		var category = _add_headline(library_name)
		for component in copyright_info:
			if component.name == library_name:
				for part in component.parts:
					var text = ""
					for copyright in part.copyright:
						text += copyright + "\n"
					text += "\n" + license_infos[part["license"]]
					_add_text(text, category, true)
				break


func _physics_process(_delta: float) -> void:
	if frames_till_autoscroll == 0:
		SCROLL_CONTAINER.scroll_vertical += AUTOMATIC_SCROLL_SPEED
	else:
		frames_till_autoscroll -= 1


func _on_scrollable_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if SCROLL_CONTAINER.scroll_vertical > SCROLL_CONTAINER.size.y - 40:
				var step = -1 * MANUAL_SCROLL_SPEED
				SCROLL_CONTAINER.scroll_vertical = max(
					SCROLL_CONTAINER.scroll_vertical + step,
					SCROLL_CONTAINER.size.y - 40
				)
				frames_till_autoscroll = 20
			else:
				frames_till_autoscroll = 60

			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var step = +1 * event.factor * MANUAL_SCROLL_SPEED
			SCROLL_CONTAINER.scroll_vertical = min(
				SCROLL_CONTAINER.scroll_vertical + step,
				CREDITS.size.y - SCROLL_CONTAINER.size.y
			)

			get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$OuterMargin/Back.emit_signal("pressed")


func _on_back_pressed() -> void:
	SceneSwitcher.go_back(self)
