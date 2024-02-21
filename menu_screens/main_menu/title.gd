@tool
extends Label


func _ready() -> void:
	_update_title()
	ProjectSettings.connect("settings_changed", _update_title)


func _update_title() -> void:
	text = ProjectSettings.get_setting("application/config/name")


func _set(property: StringName, value) -> bool:
	if property == "text":
		ProjectSettings.set_setting("application/config/name", value)
		return true  # consider property hereby handled
	return false # handle property normally


func _get_configuration_warnings() -> PackedStringArray:
	if not text:
		return ["Text should not be empty: It's synced to the game's name in the ProjectSettings."]
	return []
