extends ColorRect


func _ready() -> void:
	$OuterMargin/Categories.tab_bar_minimum_size = $OuterMargin/Back.size.x + 20


func _on_back_pressed() -> void:
	Settings.save_to_file()
	SceneSwitcher.go_back(self)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $OuterMargin/Categories.visible_tab != -1:
			$OuterMargin/Categories.focus_tab()
		else:
			$OuterMargin/Back.emit_signal("pressed")