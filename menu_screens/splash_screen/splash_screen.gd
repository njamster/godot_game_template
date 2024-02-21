extends ColorRect


func _ready() -> void:
	await get_tree().create_timer(0.8).timeout
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
