extends Node2D


@onready var PAUSE_MENU := $PauseMenu


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		PAUSE_MENU.show()
