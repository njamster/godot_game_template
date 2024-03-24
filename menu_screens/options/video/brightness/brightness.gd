extends PanelContainer


@onready var VALUE : Label = %Value


func _ready() -> void:
	$VBox/HBox/HBox.value = 0
	$VBox/HBox/HBox.connect("value_changed", _on_value_changed)


func _on_value_changed() -> void:
	WorldEnv.environment.adjustment_brightness = 1.0 + $VBox/HBox/HBox.value * 0.05
