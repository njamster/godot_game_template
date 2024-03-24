extends VBoxContainer


const FOCUSED := preload("res://menu_screens/settings/option_types/resources/focused.tres")
const UNFOCUSED := preload("res://menu_screens/settings/option_types/resources/unfocused.tres")

@onready var SEPARATOR : TextureRect = %Separator
@onready var HINT : Label = %Hint


func _ready() -> void:
	get_parent().focus_mode = Control.FOCUS_ALL
	get_parent().connect("focus_entered", _on_option_range_focus_entered)
	get_parent().connect("focus_exited", _on_option_range_focus_exited)

	_on_option_range_focus_exited()


func _on_option_range_focus_entered() -> void:
	get_parent().add_theme_stylebox_override("panel", FOCUSED)
	#if HINT.text:
		#SEPARATOR.show()
		#HINT.show()


func _on_option_range_focus_exited() -> void:
	get_parent().add_theme_stylebox_override("panel", UNFOCUSED)
	#SEPARATOR.hide()
	#HINT.hide()
