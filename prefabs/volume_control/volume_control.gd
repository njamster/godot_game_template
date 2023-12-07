@tool
extends PanelContainer

const MIN_VOLUME := 0
const MAX_VOLUME := 100
const STEP_SIZE := 10

@export var label : String:
	set(value):
		label = value
		if is_inside_tree():
			%Name.text = value
			if value:
				%Name.show()
			else:
				%Name.hide()

@export_enum("Master", "Music", "SFX", "UI") var audio_bus := 0:
	set(value):
		audio_bus = value

@export var volume := MAX_VOLUME:
	set(value):
		volume = clamp(value, MIN_VOLUME, MAX_VOLUME)
		if is_inside_tree():
			%Volume.text = str(volume) + "%"
			if volume == MIN_VOLUME:
				%Decrease.disabled = true
			elif volume == MAX_VOLUME:
				%Increase.disabled = true
			else:
				%Decrease.disabled = false
				%Increase.disabled = false
			AudioServer.set_bus_volume_db(
				audio_bus,
				linear_to_db(volume / 100.0)
			)


func _ready() -> void:
	label = label
	volume = round(db_to_linear(AudioServer.get_bus_volume_db(audio_bus)) * 100)


func _on_decrease_pressed() -> void:
	volume -= STEP_SIZE


func _on_increase_pressed() -> void:
	volume += STEP_SIZE
