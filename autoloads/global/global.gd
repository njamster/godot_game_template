extends CanvasLayer


const NOTIFICATION_SCENE := preload("res://autoloads/global/notification/notification.tscn")


enum CanvasLayers {
	PAUSE_MENU     = 126,
	GLOBAL         = 127,
	SCENE_SWITCHER = 128,
}


func _ready() -> void:
	layer = CanvasLayers.GLOBAL


func open_url(url: String) -> void:
	OS.shell_open(url)

	var notification := NOTIFICATION_SCENE.instantiate()
	$Notifications.add_child(notification)

	notification.text = "URL opened, check your browser!"
