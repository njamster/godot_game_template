extends VBoxContainer


const DEFAULT_TRANSPARENCY := 0.1
const HOVER_TRANSPARENCY := 0.6
const FOCUS_TRANSPARENCY := 1.0

var is_hovered := false


var locale : String:
	set(value):
		locale = value
		if is_inside_tree():
			if FileAccess.file_exists("res://menu_screens/language_selection/language_option/images/" + locale + ".png"):
				$Flag.texture = load("res://menu_screens/language_selection/language_option/images/" + locale + ".png")
			else:
				$Flag.texture = load("res://menu_screens/language_selection/language_option/images/unknown.png")
			var translation = TranslationServer.get_translation_object(locale)
			if translation:
				$Label.text = translation.get_message("LANG_" + locale.to_upper())
			else:
				$Label.text = "Unknown"


func _ready() -> void:
	modulate.a = DEFAULT_TRANSPARENCY


func _on_focus_entered() -> void:
	TranslationServer.set_locale(locale)
	modulate.a = FOCUS_TRANSPARENCY


func _on_focus_exited() -> void:
	if is_hovered:
		modulate.a = HOVER_TRANSPARENCY
	else:
		modulate.a = DEFAULT_TRANSPARENCY


func _on_mouse_entered() -> void:
	is_hovered = true
	if not has_focus():
		modulate.a = HOVER_TRANSPARENCY


func _on_mouse_exited() -> void:
	is_hovered = false
	if not has_focus():
		modulate.a = DEFAULT_TRANSPARENCY
