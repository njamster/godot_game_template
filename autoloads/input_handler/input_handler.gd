extends Node

var cursor_images := {
	DisplayServer.CURSOR_ARROW:
		preload("res://autoloads/input_handler/images/cursor.png"),
	DisplayServer.CURSOR_POINTING_HAND:
		preload("res://autoloads/input_handler/images/pointer.png"),
}

var pressed_images := {
	DisplayServer.CURSOR_ARROW:
		preload("res://autoloads/input_handler/images/cursor_pressed.png"),
	DisplayServer.CURSOR_POINTING_HAND:
		preload("res://autoloads/input_handler/images/pointer_pressed.png"),
}

var hotspot_offsets := {
	DisplayServer.CURSOR_ARROW:
		Vector2(5, 6),
	DisplayServer.CURSOR_POINTING_HAND:
		Vector2(11, 11),
}


func _ready() -> void:
	# remain active while the game is paused
	self.process_mode = PROCESS_MODE_ALWAYS

	DisplayServer.cursor_set_custom_image(
		cursor_images[DisplayServer.CURSOR_ARROW],
		DisplayServer.CURSOR_ARROW,
		hotspot_offsets[DisplayServer.CURSOR_ARROW]
	)
	DisplayServer.cursor_set_custom_image(
		cursor_images[DisplayServer.CURSOR_POINTING_HAND],
		DisplayServer.CURSOR_POINTING_HAND,
		hotspot_offsets[DisplayServer.CURSOR_POINTING_HAND]
	)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			DisplayServer.cursor_set_custom_image(
				pressed_images[DisplayServer.CURSOR_ARROW],
				DisplayServer.CURSOR_ARROW,
				hotspot_offsets[DisplayServer.CURSOR_ARROW]
			)
			DisplayServer.cursor_set_custom_image(
				pressed_images[DisplayServer.CURSOR_POINTING_HAND],
				DisplayServer.CURSOR_POINTING_HAND,
				hotspot_offsets[DisplayServer.CURSOR_POINTING_HAND]
			)
		else:
			DisplayServer.cursor_set_custom_image(
				cursor_images[DisplayServer.CURSOR_ARROW],
				DisplayServer.CURSOR_ARROW,
				hotspot_offsets[DisplayServer.CURSOR_ARROW]
			)
			DisplayServer.cursor_set_custom_image(
				cursor_images[DisplayServer.CURSOR_POINTING_HAND],
				DisplayServer.CURSOR_POINTING_HAND,
				hotspot_offsets[DisplayServer.CURSOR_POINTING_HAND]
			)

			# since the mouse might have been moved after pressing the button down, the mouse cursor
			# state might change after releasing the button again
			await get_tree().process_frame
			get_viewport().update_mouse_cursor_state()
