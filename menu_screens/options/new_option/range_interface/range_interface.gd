extends HBoxContainer

var option_name := ""

var MIN_VALUE := 0
var MAX_VALUE := 100
var STEP_SIZE := 10


func _ready() -> void:
	NewSettings.connect("settings_changed", _on_NewSettings_changed)
	_on_NewSettings_changed()

	await get_tree().process_frame

	$DecreaseButton.custom_minimum_size.x = $DecreaseButton.size.y
	$IncreaseButton.custom_minimum_size.x = $IncreaseButton.size.y


func _on_decrease_button_pressed() -> void:
	NewSettings[option_name] -= STEP_SIZE


func _on_increase_button_pressed() -> void:
	NewSettings[option_name] += STEP_SIZE


func _on_NewSettings_changed() -> void:
	var value = NewSettings[option_name]
	$DecreaseButton.disabled = (value == MIN_VALUE)
	$IncreaseButton.disabled = (value == MAX_VALUE)
	$Value.text = str(value)
