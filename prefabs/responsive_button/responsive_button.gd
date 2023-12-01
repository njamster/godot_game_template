class_name ResponsiveButton
extends Button


@export var focus_sound : AudioStream

var allow_focus_sound := true


func _ready() -> void:
	self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	connect("mouse_entered", _play_focus_sound)
	connect("gui_input", _on_gui_input)


func grab_focus_silently() -> void:
	allow_focus_sound = false
	grab_focus()
	allow_focus_sound = true


func _on_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_up") and find_valid_focus_neighbor(SIDE_TOP)) \
	or (event.is_action_pressed("ui_right") and find_valid_focus_neighbor(SIDE_RIGHT)) \
	or (event.is_action_pressed("ui_down") and find_valid_focus_neighbor(SIDE_BOTTOM)) \
	or (event.is_action_pressed("ui_left") and find_valid_focus_neighbor(SIDE_LEFT)) \
	or event.is_action_pressed("ui_focus_next", false, true) \
	or event.is_action_pressed("ui_focus_prev"):
		_play_focus_sound()


func _play_focus_sound() -> void:
	if not allow_focus_sound:
		return

	if focus_sound:
		SoundManager.play_ui_sound(focus_sound.resource_path)
	else:
		SoundManager.play_ui_sound("res://prefabs/responsive_button/sounds/mouse_over.ogg")
