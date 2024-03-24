extends VBoxContainer

var locale : String:
	set(value):
		locale = value
		if is_inside_tree():
			if FileAccess.file_exists("res://menu_screens/language_selection/language_option/images/" + locale + ".png"):
				$Flag.texture = load("res://menu_screens/language_selection/language_option/images/" + locale + ".png")
			else:
				$Flag.texture = load("res://menu_screens/language_selection/language_option/images/unknown.png")
			$NativeName.text = "LANG_" + locale.to_upper()
			var translation = TranslationServer.get_translation_object("en")
			$EnglishName.text = translation.get_message("LANG_" + locale.to_upper())


func _ready() -> void:
	modulate.a = 0.2


func _on_focus_entered() -> void:
	TranslationServer.set_locale(locale)
	modulate.a = 1.0


func _on_focus_exited() -> void:
	modulate.a = 0.2
