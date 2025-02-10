extends CanvasLayer


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	process_mode = PROCESS_MODE_WHEN_PAUSED

	self.hide()


func _connect_signals() -> void:
	visibility_changed.connect(_on_visibility_changed)

	%Buttons/Resume.pressed.connect(self.hide)
	%Buttons/QuitToMenu.pressed.connect(
		SceneSwitcher.change_to.bind("res://main_menu/main_menu.tscn")
	)


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		%Buttons/Resume.grab_focus()
	else:
		get_tree().paused = false
