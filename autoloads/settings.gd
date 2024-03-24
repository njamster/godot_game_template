extends Node

signal setting_updated()

const FILEPATH := "user://settings.cfg"

var fullscreen := (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN):
	set(value):
		fullscreen = value
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		emit_signal("setting_updated")


var v_sync := (DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED):
	set(value):
		v_sync = value
		if v_sync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		emit_signal("setting_updated")


func _ready() -> void:
	auto_add_translations("res://translations/")
	# if available, automatically select the system language
	var system_locale := OS.get_locale_language()
	if system_locale in  TranslationServer.get_loaded_locales():
		TranslationServer.set_locale(system_locale)
	else:
		TranslationServer.set_locale("en")

	load_from_file()


## Searches the given path for files ending in ".translation" and adds them (in alphabetical order)
## as translations to the TranslationServer. [b]Calling this will clear all existing translations![/b]
func auto_add_translations(path: String) -> void:
	TranslationServer.clear()

	var directory := DirAccess.open(path)
	if directory:
		for file_name in directory.get_files():
			if file_name.ends_with(".translation"):
				TranslationServer.add_translation(load(path + file_name))

func load_from_file() -> void:
	var settings := ConfigFile.new()
	var error := settings.load(FILEPATH)
	if error:
		return

	if settings.has_section("Volume"):
		for bus_name in settings.get_section_keys("Volume"):
			var bus_idx := AudioServer.get_bus_index(bus_name)
			if bus_idx == -1:
				push_error("Unknown bus_name '%s'" % bus_name)
			else:
				var bus_volume_percent = settings.get_value("Volume", bus_name)
				# TODO: ensure that bus_volume_percent is between 0 and 100
				var bus_volume_db = linear_to_db(bus_volume_percent / 100.0)
				AudioServer.set_bus_volume_db(bus_idx, bus_volume_db)


func save_to_file() -> void:
	var settings := ConfigFile.new()

	for i in AudioServer.bus_count:
		var bus_name := AudioServer.get_bus_name(i)
		var bus_volume_db := AudioServer.get_bus_volume_db(i)
		var bus_volume_percent := roundi(db_to_linear(bus_volume_db) * 100)
		settings.set_value("Volume", bus_name, bus_volume_percent)

	settings.save(FILEPATH)
