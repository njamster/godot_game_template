extends Node

const SAVE_PATH := "user://settings.conf"


@export_group("VIDEO")
#region: video settings
# TODO
#endregion

@export_group("AUDIO")
#region: audio settings
@export_range(0, 100) var master_volume := 100:
	set(value):
		music_volume = _set_bus_volume("Master", value)
@export_range(0, 100) var music_volume := 100:
	set(value):
		music_volume = _set_bus_volume("Music", value)
@export_range(0, 100) var sound_volume := 100:
	set(value):
		sound_volume = _set_bus_volume("SFX", value)
@export_range(0, 100) var interface_volume := 100:
	set(value):
		sound_volume = _set_bus_volume("UI", value)

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

@export_group("INPUT")
#region: input settings
# TODO
#endregion


#region: core functions - do NOT touch!
func _ready() -> void:
	load_from_file()


func load_from_file() -> void:
	var file := ConfigFile.new()

	if file.load(SAVE_PATH) != OK:
		return

	var group_names = []
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
		elif property.usage & PROPERTY_USAGE_EDITOR == 0:
			continue # no export variable
		elif group_name:
			file.set_value(group_name, property.name, self[property.name])

	file.save(SAVE_PATH)
#endregion
