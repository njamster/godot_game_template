extends ColorRect


func _ready() -> void:
	$OuterMargin/Back.grab_focus_silently()


func _on_back_pressed() -> void:
	# store settings in a file
	var settings = ConfigFile.new()
	settings.set_value("Volume", "Master", %Master.get_volume())
	settings.set_value("Volume", "Music", %Music.get_volume())
	settings.set_value("Volume", "SFX", %Sounds.get_volume())
	settings.set_value("Volume", "UI", %Interface.get_volume())
	settings.save("user://settings.cfg")

	SceneSwitcher.go_back(self)
