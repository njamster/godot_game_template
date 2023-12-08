extends Control


func _ready() -> void:
	# restore settings from a file (if existent)
	var settings = ConfigFile.new()
	var error = settings.load("user://settings.cfg")
	if not error:
		for bus_name in ["Master", "Music", "SFX", "UI"]:
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index(bus_name),
				linear_to_db(settings.get_value("Volume", bus_name) / 100.0)
			)

	await get_tree().create_timer(0.8).timeout
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
