extends Control


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	%Buttons/Play.grab_focus()


func _connect_signals() -> void:
	%Buttons/Play.pressed.connect(
		SceneSwitcher.change_to.bind("res://game/game.tscn")
	)
	%Buttons/Settings.pressed.connect(
		SceneSwitcher.change_to.bind("res://settings/settings.tscn")
	)
	%Buttons/Credits.pressed.connect(
		SceneSwitcher.change_to.bind("res://credits/credits.tscn")
	)
	%Buttons/Quit.pressed.connect(get_tree().quit)
