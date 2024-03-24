extends Label


func _ready() -> void:
	self.hide()


func _process(_delta: float) -> void:
	self.text = "FPS: %d" % Engine.get_frames_per_second()


func _on_visibility_changed() -> void:
	if self.visible:
		set_process(true)
	else:
		set_process(false)
