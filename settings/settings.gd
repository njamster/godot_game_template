extends Control


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	for bus_id in AudioServer.bus_count:
		var volume_setting = preload(
			"res://settings/volume_setting/volume_setting.tscn"
		).instantiate()
		volume_setting.bus_id = bus_id
		%AudioGroup.add_child(volume_setting)

	%BackButton.grab_focus()


func _connect_signals() -> void:
	%BackButton.pressed.connect(
		SceneSwitcher.change_to.bind("res://main_menu/main_menu.tscn")
	)
