extends CanvasLayer


const POPUP_SCENE := preload("res://autoloads/notifications/popup/popup.tscn")


func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS
	self.show()


func spawn_notification(text: String) -> void:
	var popup := POPUP_SCENE.instantiate()
	$Stack.add_child(popup)
	popup.text = text
