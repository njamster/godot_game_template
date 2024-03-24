extends ColorRect


func _ready() -> void:
	$OuterMargin/Buttons.get_child(0).grab_focus_silently()


func _on_play_pressed() -> void:
	SceneSwitcher.change_scene("res://game/game.tscn")


func _on_options_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/options/options.tscn", true)


func _on_credits_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/credits/credits.tscn", true)


func _on_exit_pressed() -> void:
	SceneSwitcher.quit_game()


func _on_author_1_pressed() -> void:
	Utils.open_url("https://mastodon.gamedev.place/@njamster")
