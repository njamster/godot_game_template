extends CanvasLayer


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	process_mode = PROCESS_MODE_ALWAYS

	self.hide()


func _connect_signals() -> void:
	visibility_changed.connect(_on_visibility_changed)

	%Buttons/ResumeGame.pressed.connect(_resume_game)
	%Buttons/QuitToMenu.pressed.connect(_quit_to_menu)


func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		%Buttons/ResumeGame.grab_focus()
	else:
		get_tree().paused = false


func _resume_game() -> void:
	self.hide()


func _quit_to_menu() -> void:
	self.hide()
	SceneSwitcher.change_to("res://main_menu/main_menu.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		self.show()
