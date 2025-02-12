extends HBoxContainer


@export var bus_id := -1:
	set(value):
		bus_id = value

		if not _has_valid_bus_id():
			push_warning(
				"Invalid 'bus_id'. Value must be >= 0 and < %d!" %
					AudioServer.bus_count
			)
			return

		$BusName.text = AudioServer.get_bus_name(bus_id)
		volume = int(db_to_linear(AudioServer.get_bus_volume_db(bus_id)) * 100)
		is_muted = AudioServer.is_bus_mute(bus_id)

@export_group("Range")
@export var min_value := 0
@export var max_value := 100

@export var step := 5


var volume: int:
	set(value):
		if not _has_valid_bus_id():
			push_warning(
				"Can't change 'volume' property. Set a valid 'bus_id' first!"
			)
			return

		volume = clamp(value, min_value, max_value)

		AudioServer.set_bus_volume_db(bus_id, linear_to_db(volume))

		$Decrease.disabled = (volume == min_value)
		$Value.text = str(volume) + " %"
		$Increase.disabled = (volume == max_value)

var is_muted: bool:
	set(value):
		if not _has_valid_bus_id():
			push_warning(
				"Can't change 'volume' property. Set a valid 'bus_id' first!"
			)
			return

		is_muted = value

		AudioServer.set_bus_mute(bus_id, is_muted)

		$Mute.text = "Unmute" if is_muted else "Mute"
		$Mute.button_pressed = is_muted


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	$Decrease.pressed.connect(change_volume.bind(-step))
	$Increase.pressed.connect(change_volume.bind(+step))

	$Mute.toggled.connect(mute)


func _has_valid_bus_id() -> bool:
	return bus_id >= 0 and bus_id < AudioServer.bus_count


func change_volume(offset: int) -> void:
	volume += offset


func mute(toggled_on: bool) -> void:
	is_muted = toggled_on
