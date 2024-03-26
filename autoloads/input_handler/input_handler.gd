@tool
extends Node


signal mode_changed()

enum Modes {
	KEYBOARD,
	CONTROLLER
}

var mode := Modes.KEYBOARD:
	set(value):
		if mode != value:
			mode = value
			if mode != Modes.KEYBOARD:
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			else:
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			emit_signal("mode_changed")

var controller_type


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
	if Engine.is_editor_hint():
		return

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

	await get_tree().process_frame
	if Input.get_connected_joypads().size() > 0:
		_get_controller_type(Input.get_connected_joypads()[0])
		self.mode = Modes.CONTROLLER


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	if event is InputEventKey or event is InputEventMouse:
		mode = Modes.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_get_controller_type(event.device)
		mode = Modes.CONTROLLER

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


func _get_controller_type(device_id : int) -> void:
	var joy_name := Input.get_joy_name(device_id)
	match joy_name:
		"Xbox 360 Controller":
			controller_type = "xbox"


func get_icon(input_action: String, outline_only := false) -> Texture2D:
	if InputMap.has_action(input_action):
		if mode == Modes.KEYBOARD:
			for event in InputMap.action_get_events(input_action):
				if event is InputEventKey:
					var key_name := OS.get_keycode_string(event.keycode).replace(" ", "_").to_lower()
					if outline_only:
						return load("res://input_icons/keyboard/outline_only/" + key_name + ".png")
					else:
						return load("res://input_icons/keyboard/" + key_name + ".png")
		elif mode == Modes.CONTROLLER:
			for event in InputMap.action_get_events(input_action):
				if event is InputEventJoypadButton:
					var key_name := str(event.button_index)
					if outline_only:
						return load("res://input_icons/" + InputHandler.controller_type + "/outline_only/" + key_name + ".png")
					else:
						return load("res://input_icons/" + InputHandler.controller_type + "/" + key_name + ".png")

	return null
