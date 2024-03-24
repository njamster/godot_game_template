extends CanvasLayer


const SETTINGS := preload("res://menu_screens/options/options.tscn")


func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS
	self.hide()


func open() -> void:
	if GameOverScreen.visible:
		return

	get_tree().paused = true
	$VBox/Buttons.get_child(0).grab_focus_silently()
	self.show()

	# since the pause menu is visible now, the mouse cursor state might change
	get_viewport().update_mouse_cursor_state()


func close() -> void:
	get_tree().paused = false
	self.hide()

	# since the pause menu is invisible now, the mouse cursor state might change
	get_viewport().update_mouse_cursor_state()


func _on_continue_pressed() -> void:
	self.close()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	self.close()


func _on_options_pressed() -> void:
	Transitions.fade_in()
	await Transitions.fade_in_finished

	var settings = SETTINGS.instantiate()
	add_child(settings)

	Transitions.fade_out()
	await Transitions.fade_out_finished

	await settings.tree_exited
	$VBox/Buttons/Options.grab_focus_silently()


func _on_main_menu_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
	await Transitions.fade_in_finished
	self.close()
