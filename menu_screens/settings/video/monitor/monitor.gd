extends PanelContainer


@onready var VALUE : Label = %Value


func _ready() -> void:
	var screen_count := DisplayServer.get_screen_count()
#
	for s in screen_count:
		$VBox/HBox/HBox.options.append(str(s+1))

	$VBox/HBox/HBox.value = DisplayServer.window_get_current_screen()

	$VBox/HBox/HBox.connect("value_changed", _on_value_changed)
#
	if screen_count <= 1:
		self.hide()


func _on_value_changed() -> void:
	# The following seems to not work in fullscreen mode:
	#DisplayServer.window_set_current_screen($VBox/HBox/HBox.value)

	# Switching into windowed mode and back only works without decorations:
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#DisplayServer.window_set_current_screen($VBox/HBox/HBox.value)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	# So this is my (pretty hacky) solution to the problem:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var offset := DisplayServer.window_get_position() - DisplayServer.window_get_position_with_decorations()
	DisplayServer.window_set_position(DisplayServer.screen_get_position($VBox/HBox/HBox.value) + offset)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
