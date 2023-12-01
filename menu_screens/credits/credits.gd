extends ColorRect


func _ready() -> void:
	$OuterMargin/Back.grab_focus_silently()


func _on_back_pressed() -> void:
	SceneSwitcher.go_back(self)
