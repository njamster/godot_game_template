extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		PauseMenu.open()
