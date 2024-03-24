extends PanelContainer


@onready var CHECK_BOX : CheckBox = %CheckBox


func _ready() -> void:
	CHECK_BOX.button_pressed = Settings.fullscreen
	CHECK_BOX.connect("toggled", _on_check_box_toggled)

	Settings.connect("setting_updated", func(): CHECK_BOX.button_pressed = Settings.fullscreen)


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.fullscreen = true
	else:
		Settings.fullscreen = false

		var offset := DisplayServer.window_get_position() - DisplayServer.window_get_position_with_decorations()
		DisplayServer.window_set_position(DisplayServer.screen_get_position(DisplayServer.window_get_current_screen()) + offset)
