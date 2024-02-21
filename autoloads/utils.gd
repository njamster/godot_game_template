extends Node


func open_url(url: String) -> void:
	OS.shell_open(url)
	Notifications.spawn_notification("URL opened, check your browser!")
