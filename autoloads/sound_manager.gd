extends Node


@onready var UI_SOUNDS := Node.new()


func _ready() -> void:
	add_child(UI_SOUNDS)
	UI_SOUNDS.name = "UI"


func play_ui_sound(path: String) -> void:
	var audio_player := AudioStreamPlayer.new()
	UI_SOUNDS.add_child(audio_player)

	audio_player.name = path.get_basename().get_file()
	audio_player.stream = load(path)
	audio_player.bus = "UI"

	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
