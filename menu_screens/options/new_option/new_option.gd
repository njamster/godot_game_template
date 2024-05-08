extends PanelContainer

const FOCUSED := preload("res://menu_screens/options/option_types/resources/focused.tres")
const UNFOCUSED := preload("res://menu_screens/options/option_types/resources/unfocused.tres")


func _ready() -> void:
	_on_focus_exited()


func _on_focus_entered() -> void:
	add_theme_stylebox_override("panel", FOCUSED)


func _on_focus_exited() -> void:
	add_theme_stylebox_override("panel", UNFOCUSED)


func set_label_text(text: String) -> void:
	$HBox/Label.text = text.to_upper()


func add_interface(scene) -> void:
	$HBox.add_child(scene)
