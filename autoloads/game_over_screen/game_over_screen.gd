extends CanvasLayer


func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS
	self.hide()


func open(reason := "") -> void:
	get_tree().paused = true
	if reason:
		%Reason.text = reason
		%Reason.show()
	else:
		%Reason.hide()
	%Buttons.get_child(0).grab_focus_silently()
	self.show()

	# since the game over screen is visible now, the mouse cursor state might change
	get_viewport().update_mouse_cursor_state()


func _close() -> void:
	get_tree().paused = false
	self.hide()

	# since the game over screen is invisible now, the mouse cursor state might change
	get_viewport().update_mouse_cursor_state()


func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()
	self._close()


func _on_quit_to_menu_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
	await Transitions.fade_in_finished
	self._close()
