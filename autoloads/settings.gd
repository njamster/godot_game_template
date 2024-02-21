extends Node


const FILEPATH := "user://settings.cfg"


func _ready() -> void:
	load_from_file()


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
