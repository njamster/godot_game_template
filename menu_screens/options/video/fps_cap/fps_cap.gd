extends HBoxContainer


@onready var OPTIONS : OptionButton = %Options


func _ready() -> void:
	OPTIONS.disabled = Settings.v_sync

	Settings.connect("setting_updated", _on_v_sync_toggled)

	OPTIONS.add_item("30", 30)
	OPTIONS.add_item("60", 60)
	OPTIONS.add_item("120", 120)
	OPTIONS.add_item("144", 144)
	OPTIONS.add_item("160", 160)
	OPTIONS.add_item("165", 165)
	OPTIONS.add_item("180", 180)
	OPTIONS.add_item("200", 200)
	OPTIONS.add_item("240", 240)
	OPTIONS.add_item("360", 360)
	OPTIONS.add_item("Unlimited", 0)


func _on_v_sync_toggled() -> void:
	OPTIONS.disabled = Settings.v_sync
	if OPTIONS.disabled:
		Engine.max_fps = 0
	else:
		Engine.max_fps = OPTIONS.get_item_id(OPTIONS.selected)


func _on_options_item_selected(index: int) -> void:
	Engine.max_fps = OPTIONS.get_item_id(index)
