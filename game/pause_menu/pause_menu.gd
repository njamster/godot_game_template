extends CanvasLayer


@onready var OVERLAY := $Overlay


func _ready() -> void:
	self.layer = Global.CanvasLayers.PAUSE_MENU
	self.hide()


func _on_visibility_changed() -> void:
	if visible:
		if is_inside_tree():
			get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		self.process_mode = Node.PROCESS_MODE_ALWAYS
		$VBox/Buttons.get_child(0).grab_focus_silently()
	else:
		if is_inside_tree():
			get_parent().process_mode = Node.PROCESS_MODE_INHERIT
		self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_resume_pressed() -> void:
	self.hide()


func _on_restart_pressed() -> void:
	SceneSwitcher.change_scene("res://game/game.tscn")


func _on_settings_pressed() -> void:
	var settings = load("res://menu_screens/settings/settings.tscn").instantiate()
	add_child(settings)
	await settings.tree_exited
	$VBox/Buttons/Settings.grab_focus_silently()


func _on_quit_to_menu_pressed() -> void:
	SceneSwitcher.change_scene("res://menu_screens/main_menu/main_menu.tscn")
