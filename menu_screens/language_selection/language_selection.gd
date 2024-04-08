extends ColorRect

const LANGUAGE_OPTION := preload("res://menu_screens/language_selection/language_option/language_option.tscn")


func _ready() -> void:
	var loaded_locales := TranslationServer.get_loaded_locales()

	if loaded_locales.size() < 2:
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://menu_screens/splash_screen/splash_screen.tscn")
		return

	for locale in loaded_locales:
		var option := LANGUAGE_OPTION.instantiate()
		%Languages.add_child(option)
		option.locale = locale

	var current_locale := TranslationServer.get_locale()
	var i := loaded_locales.find(current_locale)
	%Languages.get_child(i).grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept", false, true):
		$OuterMargin/VBox/Confirm.emit_signal("pressed")


func _on_confirm_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
