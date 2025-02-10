extends Node


func _ready() -> void:
	_set_initial_state()


func _set_initial_state() -> void:
	process_mode = PROCESS_MODE_ALWAYS


func change_to(path: String) -> void:
	get_tree().change_scene_to_file(path)
	if PauseMenu.visible:
		PauseMenu.hide()
