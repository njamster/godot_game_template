extends ColorRect


@onready var CATEGORIES := %Categories
@onready var BACK_BUTTON := %Back


func _on_back_pressed() -> void:
	#Settings.save_to_file()
	SceneSwitcher.go_back(self)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if CATEGORIES.visible_tab != -1:
			CATEGORIES.focus_tab()
		else:
			BACK_BUTTON.emit_signal("pressed")
