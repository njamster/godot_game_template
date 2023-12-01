extends CanvasLayer


const FADE_DURATION := 0.8 # seconds

var history := []

@onready var OVERLAY := $Overlay
@onready var RESTART_BUTTON := $RestartButton


func _ready() -> void:
	self.layer = Global.CanvasLayers.SCENE_SWITCHER

	OVERLAY.mouse_filter = Control.MOUSE_FILTER_IGNORE
	OVERLAY.modulate.a = 0.0

	RESTART_BUTTON.hide()


func change_scene(scene_path: String, add_to_history := false) -> void:
	OVERLAY.mouse_filter = Control.MOUSE_FILTER_STOP

	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property(
		OVERLAY,
		"modulate:a",
		1.0,
		FADE_DURATION
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await fade_in_tween.finished
	if add_to_history:
		history.append(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(scene_path)

	var fade_out_tween := get_tree().create_tween()
	fade_out_tween.tween_property(
		OVERLAY,
		"modulate:a",
		0.0,
		FADE_DURATION
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	await fade_out_tween.finished
	OVERLAY.mouse_filter = Control.MOUSE_FILTER_IGNORE


func go_back(calling_node: Node) -> void:
	if history:
		change_scene(history.pop_back())
	elif calling_node == get_tree().current_scene:
		quit_game()
	else:
		calling_node.queue_free()


func quit_game() -> void:
	OVERLAY.mouse_filter = Control.MOUSE_FILTER_STOP

	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property(
		OVERLAY,
		"modulate:a",
		1.0,
		FADE_DURATION
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	await fade_in_tween.finished
	if OS.has_feature("web"):
		RESTART_BUTTON.show()
	else:
		get_tree().quit()


func _on_restart_button_pressed() -> void:
	RESTART_BUTTON.hide()
	OVERLAY.modulate.a = 0.0
	get_tree().change_scene_to_file(ProjectSettings.get("application/run/main_scene"))
