extends ColorRect

const LANGUAGE_OPTION := preload("res://menu_screens/language_selection/language_option/language_option.tscn")


func _ready() -> void:
	auto_add_translations("res://translations/")

	var loaded_locales := TranslationServer.get_loaded_locales()

	if loaded_locales.size() < 2:
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://menu_screens/splash_screen/splash_screen.tscn")
		return

	for locale in loaded_locales:
		var option := LANGUAGE_OPTION.instantiate()
		%Languages.add_child(option)
		option.locale = locale

	# if available, automatically select the system language
	var system_locale := OS.get_locale_language()
	if system_locale in loaded_locales:
		var i := loaded_locales.find(system_locale)
		%Languages.get_child(i).grab_focus()
	else:
		TranslationServer.set_locale("en")
		var i := loaded_locales.find("en")
		%Languages.get_child(i).grab_focus()


## Searches the given path for files ending in ".translation" and adds them (in alphabetical order)
## as translations to the TranslationServer. [b]Calling this will clear all existing translations![/b]
func auto_add_translations(path: String) -> void:
	TranslationServer.clear()

	var directory := DirAccess.open(path)
	if directory:
		for file_name in directory.get_files():
			if file_name.ends_with(".translation"):
				TranslationServer.add_translation(load(path + file_name))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept", false, true):
		_on_confirm_pressed()


func _on_confirm_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/splash_screen/splash_screen.tscn")
