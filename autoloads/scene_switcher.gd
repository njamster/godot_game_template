extends Node


var history := []


func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS


func change_scene(scene_path: String, add_to_history := false) -> void:
	Transitions.fade_in()
	await Transitions.fade_in_finished

	if add_to_history:
		history.append(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(scene_path)

	Transitions.fade_out()
	await Transitions.fade_out_finished


func go_back(calling_node: Node) -> void:
	if history:
		change_scene(history.pop_back())
	elif calling_node == get_tree().current_scene:
		quit_game()
	else:
		Transitions.fade_in()
		await Transitions.fade_in_finished
		calling_node.queue_free()
		Transitions.fade_out()


func quit_game() -> void:
	Transitions.fade_in()
	await Transitions.fade_in_finished

	if OS.has_feature("web"):
		Transitions.show_restart_button()
	else:
		get_tree().quit()
