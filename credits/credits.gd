extends Control


func _ready() -> void:
	_set_initial_state()
	_connect_signals()


func _set_initial_state() -> void:
	_parse_credits_file()

	%BackButton.grab_focus()


func _connect_signals() -> void:
	%BackButton.pressed.connect(
		SceneSwitcher.change_to.bind("res://main_menu/main_menu.tscn")
	)


func _parse_credits_file() -> void:
	var file = FileAccess.open("res://CREDITS.txt", FileAccess.READ)
	var content = file.get_as_text()

	#region Auto-adjust formatting
	var regex := RegEx.new()
	# 1) Remove leading whitespace (in each line)
	regex.compile("(?<keep>\n)[ \t]+")
	content = regex.sub(content, "${keep}", true)
	# 2) Erase any repeated whitespace
	regex.compile("[ \t]+")
	content = regex.sub(content, " ", true)
	# 3) Remove stand-alone comments
	regex.compile("\n# .*\n")
	content = regex.sub(content, "", true)
	# 4) Remove inline comments
	regex.compile("# .*\n")
	content = regex.sub(content, "\n", true)
	# 5) Replace GODOT_VERSION tag
	content = content.replace("[GODOT_VERSION]", "v%d.%d-%s" % [
		Engine.get_version_info().major,
		Engine.get_version_info().minor,
		Engine.get_version_info().status
	])
	# 6) Remove leading/trailing whitespace
	content = content.strip_edges()
	#endregion

	var rich_text_label = RichTextLabel.new()
	rich_text_label.add_theme_constant_override("line_separation", 4)
	rich_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rich_text_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rich_text_label.bbcode_enabled = true
	rich_text_label.text = "[center]%s[/center]" % content
	rich_text_label.meta_clicked.connect(_on_hyperlink_clicked)
	%Credits.add_child(rich_text_label)


func _on_hyperlink_clicked(link: String) -> void:
	OS.shell_open(link)
