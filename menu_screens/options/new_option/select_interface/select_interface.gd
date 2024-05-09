extends HBoxContainer

var option_name := ""

var options = []
var selected_id


func _ready() -> void:
	NewSettings.connect("settings_changed", _on_NewSettings_changed)
	_on_NewSettings_changed()

	await get_tree().process_frame

	$DecreaseButton.custom_minimum_size.x = $DecreaseButton.size.y
	$IncreaseButton.custom_minimum_size.x = $IncreaseButton.size.y


func _on_decrease_button_pressed() -> void:
	selected_id -= 1
	NewSettings[option_name] = options[selected_id]


func _on_increase_button_pressed() -> void:
	selected_id += 1
	NewSettings[option_name] = options[selected_id]


func _on_NewSettings_changed() -> void:
	var value = NewSettings[option_name]
	selected_id = options.find(value)
	$DecreaseButton.disabled = (selected_id == 0)
	$IncreaseButton.disabled = (selected_id == options.size() - 1)
	$Value.text = options[selected_id]
