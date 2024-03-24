extends HBoxContainer

signal value_changed

@export var MIN_VALUE := 0
@export var MAX_VALUE := 100
@export var STEP_SIZE := 10

@onready var PARENT_PANEL := get_node("../../..")
@onready var DECREASE_BUTTON : ResponsiveButton = $DecreaseValue
@onready var INCREASE_BUTTON : ResponsiveButton = $IncreaseValue

var value := MAX_VALUE:
	set(v):
		value = clamp(v, MIN_VALUE, MAX_VALUE)
		emit_signal("value_changed")
		if is_inside_tree():
			$Value.text = str(value)
			if value == MIN_VALUE:
				DECREASE_BUTTON.disabled = true
				INCREASE_BUTTON.disabled = false
			elif value == MAX_VALUE:
				DECREASE_BUTTON.disabled = false
				INCREASE_BUTTON.disabled = true
			else:
				DECREASE_BUTTON.disabled = false
				INCREASE_BUTTON.disabled = false


func _ready() -> void:
	DECREASE_BUTTON.connect("pressed", _on_decrease_value_pressed)
	INCREASE_BUTTON.connect("pressed", _on_increase_value_pressed)

	value = value

	await get_tree().process_frame
	PARENT_PANEL.connect("gui_input", _on_option_toggle_gui_input)


func _on_decrease_value_pressed() -> void:
	value -= STEP_SIZE
	PARENT_PANEL.grab_focus()


func _on_increase_value_pressed() -> void:
	value += STEP_SIZE
	PARENT_PANEL.grab_focus()


func _on_option_toggle_gui_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_left") and not DECREASE_BUTTON.disabled:
		DECREASE_BUTTON.emit_signal("pressed")
	elif Input.is_action_pressed("ui_right") and not INCREASE_BUTTON.disabled:
		INCREASE_BUTTON.emit_signal("pressed")
