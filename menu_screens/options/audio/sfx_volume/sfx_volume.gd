extends PanelContainer

@onready var audio_bus := AudioServer.get_bus_index("SFX")


func _ready() -> void:
	$VBox/HBox/HBox.value = round(db_to_linear(AudioServer.get_bus_volume_db(audio_bus)) * 100)

	$VBox/HBox/HBox.connect("value_changed", _on_value_changed)


func _on_value_changed() -> void:
	AudioServer.set_bus_volume_db(audio_bus, linear_to_db($VBox/HBox/HBox.value / 100.0))
