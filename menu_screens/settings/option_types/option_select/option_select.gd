extends HBoxContainer

signal value_changed

@onready var PARENT_PANEL := get_node("../../..")
@onready var DECREASE_BUTTON : ResponsiveButton = $PreviousValue
@onready var INCREASE_BUTTON : ResponsiveButton = $NextValue

var options := []

var value := 0:
	set(v):
		value = clamp(v, 0, options.size())
		emit_signal("value_changed")
		if is_inside_tree():
			if options.size() > 0:
				$Value.text = options[value]
				DECREASE_BUTTON.disabled = (value == 0)
				INCREASE_BUTTON.disabled = (value == options.size()-1)
			else:
				$Value.text = "ERR"
				DECREASE_BUTTON.disabled = true
				INCREASE_BUTTON.disabled = true


func _ready() -> void:
	DECREASE_BUTTON.connect("pressed", _on_decrease_value_pressed)
	INCREASE_BUTTON.connect("pressed", _on_increase_value_pressed)

	value = value

	await get_tree().process_frame
	PARENT_PANEL.connect("gui_input", _on_option_toggle_gui_input)


func _on_decrease_value_pressed() -> void:
	value -= 1
	PARENT_PANEL.grab_focus()


func _on_increase_value_pressed() -> void:
	value += 1
	PARENT_PANEL.grab_focus()


func _on_option_toggle_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left") and not DECREASE_BUTTON.disabled:
		DECREASE_BUTTON.emit_signal("pressed")
	elif Input.is_action_just_pressed("ui_right") and not INCREASE_BUTTON.disabled:
		INCREASE_BUTTON.emit_signal("pressed")
