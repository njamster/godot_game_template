extends PanelContainer


const OPTION_INPUT := preload("res://menu_screens/options/option_types/option_input/option_input.tscn")


func _ready() -> void:
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action):
			var option := OPTION_INPUT.instantiate()
			$Scrollable/Options.add_child(option)
			option.input_action = action


func focus_first_option() -> void:
	$Scrollable/Options.get_child(0).grab_focus()
