extends ColorRect


func _ready() -> void:
	$OuterMargin/VBox/Back.grab_focus_silently()


func _on_back_pressed() -> void:
	Settings.save_to_file()
	SceneSwitcher.go_back(self)
