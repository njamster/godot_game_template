extends HBoxContainer

var option_name := ""


func _ready() -> void:
	NewSettings.connect("settings_changed", _on_NewSettings_changed)
	_on_NewSettings_changed()


func _on_NewSettings_changed() -> void:
	$CheckBox.button_pressed = NewSettings[option_name]


func _on_check_box_pressed() -> void:
	NewSettings[option_name] = not NewSettings[option_name]
