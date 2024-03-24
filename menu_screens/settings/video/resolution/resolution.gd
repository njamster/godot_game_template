extends PanelContainer


const RESOLUTION_DICTIONARY := {
	"640 x 480": Vector2i(640, 480),     # 480p
	"1280 x 720": Vector2i(1280, 720),   # 720p
	"1920 x 1080": Vector2i(1920, 1080), # 1080p
	"2560 x 1440": Vector2i(2560, 1440), # 1440p
	"3840 x 2160": Vector2i(3840, 2160), # 4K
}

@onready var VALUE : Label = %Value


func _ready() -> void:
	var current_screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(current_screen)

	for key in RESOLUTION_DICTIONARY:
		var value = RESOLUTION_DICTIONARY[key]
		if value.x < screen_size.x and value.y < screen_size.y:
			$VBox/HBox/HBox.options.append(key)

	$VBox/HBox/HBox.value = $VBox/HBox/HBox.options.size() - 1

	$VBox/HBox/HBox.connect("value_changed", _on_value_changed)


func _on_value_changed() -> void:
	var selected_resolution : Vector2i = RESOLUTION_DICTIONARY.values()[$VBox/HBox/HBox.value]

	# set window size to the selected value
	DisplayServer.window_set_size(selected_resolution)

	var current_screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(current_screen)

	# center window on the current screen
	DisplayServer.window_set_position(0.5 * (screen_size - selected_resolution))
