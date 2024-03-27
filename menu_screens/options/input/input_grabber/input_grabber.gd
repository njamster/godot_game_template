extends PanelContainer


@export var input_action : String
var input_mode


func _ready() -> void:
	if input_mode == InputHandler.Modes.KEYBOARD:
		$Prompt.text = "Press any key on your keyboard to map it to '%s'" % tr(input_action.to_upper())
	elif input_mode == InputHandler.Modes.CONTROLLER:
		$Prompt.text = "Press any key on your controller to map it to '%s'" % tr(input_action.to_upper())


func _input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()

	if input_mode == InputHandler.Modes.KEYBOARD:
		if event is InputEventKey and event.pressed:
			var old_events := InputMap.action_get_events(input_action)
			for i in old_events.size():
				if old_events[i] is InputEventKey:
					old_events[i] = event
					break
			InputMap.action_erase_events(input_action)
			for new_event in old_events:
				InputMap.action_add_event(input_action, new_event)
			InputHandler.emit_signal("mode_changed")
			queue_free()
	elif input_mode == InputHandler.Modes.CONTROLLER:
		if (event is InputEventJoypadButton and event.pressed) or (event is InputEventJoypadMotion and abs(event.axis_value) == 1.0):
			var old_events := InputMap.action_get_events(input_action)
			for i in old_events.size():
				if old_events[i] is InputEventJoypadButton or old_events[i] is InputEventJoypadMotion:
					old_events[i] = event
					break
			InputMap.action_erase_events(input_action)
			for new_event in old_events:
				InputMap.action_add_event(input_action, new_event)
			InputHandler.emit_signal("mode_changed")
			queue_free()
