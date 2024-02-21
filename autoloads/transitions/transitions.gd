extends CanvasLayer

signal fade_in_finished()
signal fade_out_finished()


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	$Overlay.modulate.a = 0.0
	$RestartButton.hide()
	self.show()


func fade_in(fade_duration := 0.8) -> void:
	$Overlay.mouse_filter = Control.MOUSE_FILTER_STOP

	var fade_in_tween := create_tween()
	fade_in_tween.tween_property(
		$Overlay,
		"modulate:a",
		1.0,
		fade_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await fade_in_tween.finished
	emit_signal("fade_in_finished")


func fade_out(fade_duration := 0.8) -> void:
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(
		$Overlay,
		"modulate:a",
		0.0,
		fade_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	await fade_out_tween.finished
	$Overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# since the overlay is ignored now, the mouse cursor state might change
	get_viewport().update_mouse_cursor_state()
	emit_signal("fade_out_finished")


func show_restart_button() -> void:
	$RestartButton.show()


func _on_restart_button_pressed() -> void:
	$RestartButton.hide()
	$Overlay.modulate.a = 0.0
	get_tree().change_scene_to_file(ProjectSettings.get("application/run/main_scene"))
