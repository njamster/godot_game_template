extends ColorRect

const CATEGORY_SCENE := preload("res://menu_screens/options/category.tscn")
const NEW_OPTION_SCENE := preload("res://menu_screens/options/new_option/new_option.tscn")

@onready var CATEGORIES := %Categories
@onready var BACK_BUTTON := %Back


func _ready() -> void:
	var current_category
	for property in NewSettings.get_script().get_script_property_list():
		if property.usage == PROPERTY_USAGE_GROUP:
			current_category = CATEGORY_SCENE.instantiate()
			CATEGORIES.add_child(current_category)
			current_category.name = property.name
		elif current_category and property.usage & PROPERTY_USAGE_EDITOR:
			var option = NEW_OPTION_SCENE.instantiate()
			current_category.get_node("Scrollable/Options").add_child(option)
			option.set_label_text(property.name)

			if property.hint == PROPERTY_HINT_ENUM:
				var interface = preload("res://menu_screens/options/new_option/select_interface/select_interface.tscn").instantiate()
				interface.option_name = property.name
				interface.options = property.hint_string.split(",")
				option.add_interface(interface)
				continue

			match typeof(NewSettings[property.name]):
				TYPE_INT:
					var interface = preload("res://menu_screens/options/new_option/range_interface/range_interface.tscn").instantiate()
					interface.option_name = property.name
					var hint_string = property.hint_string.split(",")
					interface.MIN_VALUE = hint_string[0]
					interface.MAX_VALUE = hint_string[1]
					interface.STEP_SIZE = hint_string[2]
					option.add_interface(interface)
				TYPE_BOOL:
					var interface = preload("res://menu_screens/options/new_option/toggle_interface/toggle_interface.tscn").instantiate()
					interface.option_name = property.name
					option.add_interface(interface)

	# delete empty categories
	for category in CATEGORIES.get_children():
		if category.get_node("Scrollable/Options").get_child_count() == 0:
			category.free()


func _on_back_pressed() -> void:
	NewSettings.save_to_file()
	SceneSwitcher.go_back(self)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if CATEGORIES.visible_tab != -1:
			CATEGORIES.focus_tab()
		else:
			BACK_BUTTON.emit_signal("pressed")
