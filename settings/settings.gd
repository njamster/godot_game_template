extends Control


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	%BackButton.grab_focus()


func _connect_signals() -> void:
	%BackButton.pressed.connect(
		SceneSwitcher.change_to.bind("res://main_menu/main_menu.tscn")
	)
