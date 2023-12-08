extends CanvasLayer


const POPUP_SCENE := preload("res://autoloads/global/popup/popup.tscn")


enum CanvasLayers {
	PAUSE_MENU     = 126,
	GLOBAL         = 127,
	SCENE_SWITCHER = 128,
}


func _ready() -> void:
	layer = CanvasLayers.GLOBAL


func open_url(url: String) -> void:
	OS.shell_open(url)

	var popup := POPUP_SCENE.instantiate()
	$Notifications.add_child(popup)

	popup.text = "URL opened, check your browser!"
