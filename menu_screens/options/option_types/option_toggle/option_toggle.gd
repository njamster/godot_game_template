extends CheckBox


@onready var PARENT_PANEL := get_node("../../..")


func _ready() -> void:
	await get_tree().process_frame # so the initial value can be set first
	connect("toggled", _on_check_box_toggled)

	PARENT_PANEL.connect("gui_input", _on_option_toggle_gui_input)


func _on_option_toggle_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		button_pressed = not button_pressed


func _on_check_box_toggled(_toggled_on: bool) -> void:
	get_node("../../..").grab_focus()
