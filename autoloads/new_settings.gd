extends Node

signal settings_changed()


const SAVE_PATH := "user://settings.cfg"


@export_group("Video")
#region: video settings
@export var fullscreen := true:
	set(value):
		fullscreen = value
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			# without this "fix", setting fullscreen to false on my second monitor will move the window to the first monitor again
			var offset := DisplayServer.window_get_position() - DisplayServer.window_get_position_with_decorations()
			DisplayServer.window_set_position(DisplayServer.screen_get_position(DisplayServer.window_get_current_screen()) + offset)
		settings_changed.emit()

@export var show_fps := false:
	set(value):
		show_fps = value
		Transitions.get_node("FPS").visible = show_fps
		settings_changed.emit()

@export var v_sync := true:
	set(value):
		v_sync = value
		if v_sync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		settings_changed.emit()

@export_enum("30", "60", "120", "144", "160", "165", "180", "200", "240", "360", "Unlimited") var fps_cap := "60":
	set(value):
		fps_cap = value
		if fps_cap == "Unlimited":
			Engine.max_fps = 0
		else:
			Engine.max_fps = int(value)
		settings_changed.emit()

@export_range(-10, 10, 1) var contrast := 0:
	set(value):
		contrast = value
		WorldEnv.environment.adjustment_contrast = 1.0 + contrast * 0.05
		settings_changed.emit()

@export_range(-10, 10, 1) var brightness := 0:
	set(value):
		brightness = value
		WorldEnv.environment.adjustment_brightness = 1.0 + brightness * 0.05
		settings_changed.emit()

# TODO: remaining settings
#endregion

@export_group("Audio")
#region: audio settings
@export_range(0, 100, 10) var master_volume := 100:
	set(value):
		master_volume = _set_bus_volume("Master", value)
		settings_changed.emit()

@export_range(0, 100, 10) var music_volume := 100:
	set(value):
		music_volume = _set_bus_volume("Music", value)
		settings_changed.emit()

@export_range(0, 100, 10) var sound_volume := 100:
	set(value):
		sound_volume = _set_bus_volume("SFX", value)
		settings_changed.emit()

@export_range(0, 100, 10) var interface_volume := 100:
	set(value):
		interface_volume = _set_bus_volume("UI", value)
		settings_changed.emit()

func _set_bus_volume(bus_name: String, volume : int) -> int:
	volume = clamp(volume, 0, 100)

	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Unknown bus_name '%s'" % bus_name)
	else:
		var decibel = linear_to_db(volume / 100.0)
		AudioServer.set_bus_volume_db(bus_index, decibel)

	return volume
#endregion

@export_group("Input")
#region: input settings
# TODO
#endregion


#region: core functions - do NOT touch!
func _ready() -> void:
	for property in get_script().get_script_property_list():
		if property.usage & PROPERTY_USAGE_EDITOR:
			self[property.name] = self[property.name]

	load_from_file()


func load_from_file() -> void:
	var file := ConfigFile.new()

	if file.load(SAVE_PATH) != OK:
		return

	var group_names := []
	for property in get_script().get_script_property_list():
		if property.usage == PROPERTY_USAGE_GROUP:
			group_names.append(property.name)

	for section_name in file.get_sections():
		if section_name in group_names:
			for key_name in file.get_section_keys(section_name):
				if key_name in self:
					var value = file.get_value(section_name, key_name)
					var expected_type := typeof(self[key_name])
					var actual_type := typeof(value)
					if actual_type != expected_type:
						push_warning("'%s/%s' must be %s, but is %s" % [section_name, key_name, type_string(expected_type).to_upper(), type_string(actual_type).to_upper()])
					else:
						self[key_name] = file.get_value(section_name, key_name)
				else:
					push_warning("Unknown key_name '%s/%s'" % [section_name, key_name])
		else:
			push_warning("Unknown section_name '%s'" % section_name)


func save_to_file() -> void:
	var file := ConfigFile.new()

	var group_name := ""
	for property in get_script().get_script_property_list():
		if property.usage == PROPERTY_USAGE_GROUP:
			group_name = property.name
		elif group_name and property.usage & PROPERTY_USAGE_EDITOR:
			file.set_value(group_name, property.name, self[property.name])

	file.save(SAVE_PATH)
#endregion
