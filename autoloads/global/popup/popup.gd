extends PanelContainer


@export var text : String:
	set(value):
		$InnerMargin/Text.text = value


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.25, 1.4)
	tween.connect("finished", queue_free)
