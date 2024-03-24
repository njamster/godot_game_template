extends PanelContainer


@onready var CHECK_BOX : CheckBox = %CheckBox


func _ready() -> void:
	CHECK_BOX.connect("toggled", _on_check_box_toggled)


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Transitions.get_node("FPS").show()
	else:
		Transitions.get_node("FPS").hide()
