extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		PauseMenu.show()


func _process(delta: float) -> void:
	%PathFollow2D.progress += 300 * delta
