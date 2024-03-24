extends PanelContainer


func focus_first_option() -> void:
	$Scrollable/Options.get_child(0).grab_focus()
