extends ColorRect


func _on_back_pressed() -> void:
	Settings.save_to_file()
	SceneSwitcher.go_back(self)


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $OuterMargin/Categories.visible_tab != -1:
			$OuterMargin/Categories.focus_tab()
		else:
			$OuterMargin/Back.emit_signal("pressed")
