extends PanelContainer


@onready var CHECK_BOX : CheckBox = %CheckBox


func _ready() -> void:
	CHECK_BOX.button_pressed = Settings.v_sync
	CHECK_BOX.connect("toggled", _on_check_box_toggled)


func _on_check_box_toggled(toggled_on: bool) -> void:
	Settings.v_sync = toggled_on
